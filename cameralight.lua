local function readSecret(name)
    local secretFile = io.open(hs.configdir .. '/secrets/' .. name, 'r')
    if secretFile == nil then
        return
    end
    local value = secretFile:read('*a'):match('^%s*(.-)%s*$')
    secretFile:close()
    if value ~= '' then
        return value
    end
end

local function setupCameraHook()
    local homeAssistantUrl = readSecret('home_assistant_api_url')
    local homeAssistantToken = readSecret('home_assistant_token')
    if homeAssistantUrl == nil or homeAssistantToken == nil then
        return
    end
    homeAssistantUrl = homeAssistantUrl:gsub('/+$', '')  -- strip trailing slash

    CameraWatcher = hs.usb.watcher.new(function(event)
        if event['productName'] ~= 'ILCE-7RM2' then
            return
        end

        local endpoint
        if event['eventType'] == 'added' then
            endpoint = 'turn_on'
        else
            endpoint = 'turn_off'
        end

        hs.http.post(
            homeAssistantUrl .. '/services/light/' .. endpoint,
            hs.json.encode({ entity_id = 'light.workshop_key_light' }),
            { Authorization = 'Bearer ' .. homeAssistantToken }
        )
    end)

    CameraWatcher:start()
end

setupCameraHook()
