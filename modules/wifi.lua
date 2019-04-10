local config = require "modules/config"

wifiWatcher = nil

function ssidChangedCallback()
    availableNetworks = hs.wifi.availableNetworks()
    newSSID = hs.wifi.currentNetwork()

    -- rewrite nil to empty string for log
    if (newSSID == nil) then newSSID = "" end

    -- Identify home WiFi network
    if table.contains(availableNetworks, config.wifi.homeSSID) then
        
        -- try ssh router to get mentohust login
        hs.wifi.associate(config.wifi.homeSSID, config.wifi.homePass )

        -- confirm connected wifi in home
        repeat
            newSSID = hs.wifi.currentNetwork()
            if not table.contains(hs.wifi.availableNetworks(), config.wifi.homeSSID) then
                break
            end
        until
            newSSID == config.wifi.homeSSID
     
        -- get mentohust authorization
        local ret = os.execute("ssh root@192.168.1.1 \"mentohust -p"..config.wifi.hustPass.."\"");
        if ret ~= 0 then
            print("the system shell is available, ret = "..ret.."\n\n")
        else
            print("the system shell is not available, ret = "..ret.."\n\n")
        end

        -- alert and log status
        hs.alert("Detected at Home")
        print("ssid = "..(newSSID))

    -- Identify school WIFI network
    elseif (not table.contains(availableNetworks, config.wifi.homeSSID)) and table.contains(availableNetworks, config.wifi.schoolSSID) then
        -- hs.audiodevice.defaultOutputDevice():setVolume(0)
        hs.alert("Detected at School")
        print("ssid = "..(newSSID))

    -- Identify outside WIFI Inetwork
    elseif (not table.contains(availableNetworks, config.wifi.homeSSID)) and (not table.contains(availableNetworks, config.wifi.schoolSSID)) then
        hs.alert("Detected at Outside")
        print("ssid = "..(newSSID))
    end
end


wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()