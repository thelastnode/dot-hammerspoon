local function withDb(callback)
    --- @diagnostic disable-next-line: undefined-field
    local db = hs.sqlite3.open(hs.configdir .. '/data/timetracker.sqlite3')
    callback(db)
    db:close()
end

local function runSql(sql)
    withDb(function(db)
        db:exec(sql)
    end)
end

local function createTable()
    runSql([[
        CREATE TABLE IF NOT EXISTS focused_app (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp INTEGER DEFAULT (unixepoch('subsecond')),
            app TEXT NOT NULL,
            title TEXT NOT NULL,
            data TEXT
        );
        CREATE INDEX IF NOT EXISTS idx_focused_app_timestamp ON focused_app (timestamp);

        CREATE TABLE IF NOT EXISTS screen_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp INTEGER DEFAULT (unixepoch('subsecond')),
            state TEXT CHECK(state IN ('locked', 'unlocked')) NOT NULL
        );
        CREATE INDEX IF NOT EXISTS idx_screen_state_timestamp ON screen_state (timestamp);
    ]])
end
createTable()

SleepWatcher = hs.caffeinate.watcher.new(function(eventType)
    if (eventType == hs.caffeinate.watcher.screensDidLock) then
        runSql([[
            INSERT INTO screen_state (state) VALUES ('locked');
        ]])
    elseif (eventType == hs.caffeinate.watcher.screensDidUnlock) then
        runSql([[
            INSERT INTO screen_state (state) VALUES ('unlocked');
        ]])
    end
end)
SleepWatcher:start()

local function getChromeUrl(axwin, callback)
    local function handleChromeElementSearch(msg, elements)
        local url = elements[1].AXValue
        callback(url)
    end
    local search = axwin:elementSearch(handleChromeElementSearch,
        hs.axuielement.searchCriteriaFunction('AXTextField'), { count = 1 })
end

local function logUrl(app, title, url)
    withDb(function(db)
        local stmt = db:prepare([[
            INSERT INTO focused_app (app, title, data) VALUES ($app, $title, $data);
        ]])
        stmt:bind_names({
            app = app,
            title = title,
            data = hs.json.encode({ url = url }),
        })
        stmt:step()
    end)
end

--- @type hs.uielement.watcher | nil
local chromeTabWatcher = nil

--- @param window hs.window
local function updateChromeTabWatcher(window)
    if chromeTabWatcher ~= nil then
        chromeTabWatcher:stop()
    end

    --- @diagnostic disable-next-line: undefined-field
    chromeTabWatcher = window:newWatcher(function()
        local axwin = hs.axuielement.windowElement(window)
        getChromeUrl(axwin, function(url)
            --- @diagnostic disable-next-line: undefined-field
            logUrl(window:application():name(), window:title(), url)
        end)
    end)
    --- @diagnostic disable-next-line: undefined-field
    chromeTabWatcher:start({ hs.uielement.watcher.titleChanged })
end

--- @param window hs.window
local function logChromeWindow(window)
    -- Chrome has the "Find in page" dialog as a separate "window" - ignore it
    if window:title():find('^Find in page\n') ~= nil then
        return
    end
    local axwin = hs.axuielement.windowElement(window)

    -- listen for tab changes
    updateChromeTabWatcher(window)

    --- @param url string
    getChromeUrl(axwin, function(url)
        --- @diagnostic disable-next-line: undefined-field
        logUrl(window:application():name(), window:title(), url)
    end)
end

--- @param window hs.window
local function logRegularWindow(window)
    withDb(function(db)
        local stmt = db:prepare([[
            INSERT INTO focused_app (app, title) VALUES ($app, $title);
        ]])
        stmt:bind_names({
            --- @diagnostic disable-next-line: undefined-field
            app = window:application():name(),
            title = window:title(),
        })
        stmt:step()
    end)
end

local windowFilter = hs.window.filter.new(true);
windowFilter:subscribe(hs.window.filter.windowFocused, function()
    local focused = hs.window.focusedWindow()
    local app = focused:application()

    -- when the screen is locked, the focused window is loginwindow - ignore it
    if app ~= nil and app:name() == 'loginwindow' then
        return
    end

    -- special handling for Google Chrome and Island
    if app ~= nil and (app:name() == 'Google Chrome' or app:name() == 'Island') then
        logChromeWindow(focused)
        return
    end

    logRegularWindow(focused)
end)
