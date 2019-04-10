wifiWatcher = nil
homeSSID = "The Devil's Tears 5G"
lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        -- hs.audiodevice.defaultOutputDevice():setVolume(25)
        print("ssid = "..(newSSID))
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        -- hs.audiodevice.defaultOutputDevice():setVolume(0)
        print("ssid = "..(newSSID))
    end

    lastSSID = newSSID
end


wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()