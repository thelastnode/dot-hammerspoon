local homeAssistantUrl = 'http://bigblackbox.local:8123/api'
local homeAssistantSecretFile = hs.configdir .. '/secrets/homeassistant'

local function setupCameraHook()
    local secretFile = io.open(homeAssistantSecretFile, 'r')
    if secretFile == nil then
        return
    end
    local homeAssistantToken = secretFile:read('a')
    secretFile:close()

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
