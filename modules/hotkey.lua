hs.hotkey.bind({'cmd', 'shift'}, 'h', function()
    hs.alert(hs.wifi.currentNetwork())
end)