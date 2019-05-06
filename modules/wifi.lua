local config = require "modules/config"

wifiWatcher = nil

function ssidChangedCallback()
    availableNetworks = hs.wifi.availableNetworks()
    newSSID = hs.wifi.currentNetwork()

    -- rewrite nil to empty string for log
    if (newSSID == nil) then newSSID = "" end
    if (availableNetworks == nil) then availableNetworks = {} end

    -- Identify home WiFi network
    if table.contains(availableNetworks, config.wifi.homeSSID) then
        hs.audiodevice.defaultOutputDevice():setVolume(25)
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

        -- Check network connection 
        if  checkNetworks() then
            hs.alert('network status: OK')
            print('network status: OK')
            return
            
        else
            hs.alert('network status: Failed, trying to reconnect')
            print('network status: Failed, trying to reconnect')

            -- get mentohust authorization
            os.execute("ssh root@192.168.1.1 \"mentohust -k\"");
            os.execute("ssh root@192.168.1.1 \"mentohust -p"..config.wifi.hustPass.."\"");

            -- waiting for connection established
            os.execute("sleep 2") 
        end
 
        print("ssid = "..(newSSID))


    -- Identify studio WiFi network
    elseif table.contains(availableNetworks, config.wifi.studioSSID) then
        -- alert and log status
        hs.alert("Detected at Studio")
        
        hs.audiodevice.defaultOutputDevice():setVolume(0)
        -- confirm connected wifi in home
        while(newSSID ~= config.wifi.studioSSID) 
        do
            print("connect studioSSID")
            newSSID = hs.wifi.currentNetwork()
            -- hs.wifi.associate(config.wifi.studioSSID, config.wifi.studioPass)

            -- waiting for connection established
            os.execute("sleep 2") 

            -- break when connection failed
            if not table.contains(hs.wifi.availableNetworks(), config.wifi.studioSSID) then
                break
            end
        end


        if checkNetworks() then
            print('network status: OK')
            return
        else
            print('network status: Failed, trying to reconnect')
            -- get mentohust authorization
            os.execute("ssh root@192.168.1.1 \"mentohust -k\"");
            os.execute("ssh root@192.168.1.1 \"mentohust -u"..config.wifi.hustAccount.." -p"..config.wifi.hustPass.."\"");
            print("ssh root@192.168.1.1 \"mentohust -b1 -u"..config.wifi.hustAccount.." -p"..config.wifi.hustPass.."\"")
            os.execute("sleep 2") 

        end
        print("ssid = "..(newSSID))

    -- Identify school WIFI network
    elseif (not table.contains(availableNetworks, config.wifi.homeSSID)) and table.contains(availableNetworks, config.wifi.schoolSSID) then
        hs.audiodevice.defaultOutputDevice():setVolume(0)
        hs.alert("Detected at School")
        print("ssid = "..(newSSID))

    -- Identify outside WIFI Inetwork
    elseif isempty(availableNetworks) or (not table.contains(availableNetworks, config.wifi.homeSSID)) and (not table.contains(availableNetworks, config.wifi.schoolSSID)) then
        hs.audiodevice.defaultOutputDevice():setVolume(0)
        hs.alert("Detected at Outside")
        print("ssid = "..(newSSID))
    end

end

function checkNetworks()
    code, body, headers = hs.http.get("https://www.baidu.com", nil)
    if (code >= 200 and code < 300) then return true
    else return false end
end 

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()