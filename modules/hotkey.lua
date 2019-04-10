hs.hotkey.bind({'cmd', 'shift'}, 'h', function()
    -- for k, v in ipairs(hs.wifi.availableNetworks())  do
    --     hs.alert(v)
    -- end
    -- hs.alert(#hs.wifi.availableNetworks())
    hs.alert(not table.contains(hs.wifi.availableNetworks(), "HUST_WIRELESS_AUTO"))
end)