local config = require "modules/config"

wifiWatcher = nil

function ssidChangedCallback()
    availableNetworks = hs.wifi.availableNetworks()
    newSSID = hs.wifi.currentNetwork()

    -- rewrite nil to empty string for log
    if (newSSID == nil) then newSSID = "" end

    -- Identify home WiFi network
    if table.contains(availableNetworks, config.wifi.homeSSID) then
        
        -- confirm connected wifi in home
        while(newSSID ~= config.wifi.homeSSID) 
        do
            print("connect homeSSID")
            newSSID = hs.wifi.currentNetwork()
            hs.wifi.associate(config.wifi.homeSSID, config.wifi.homePass)

            -- waiting for connection established
            os.execute("sleep 2")

            -- break when connection failed
            if not table.contains(hs.wifi.availableNetworks(), config.wifi.homeSSID) then
                break
            end
        end 
     
        -- check network connection 
        code, body, htable = hs.http.get("https://baidu.com", nil)
        if code >= 200 and code <= 300 then
            print('network status: OK')
            return
        else
            print('network status: Failed, trying to reconnect')
            -- get mentohust authorization
            os.execute("ssh root@192.168.1.1 \"mentohust -k\"");
            os.execute("ssh root@192.168.1.1 \"mentohust -p"..config.wifi.hustPass.."\"");
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