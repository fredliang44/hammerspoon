local config = require "modules/config"

hs.hotkey.bind({'cmd', 'shift'}, 'h', function()
    hs.alert(checkNetworks())
end)


function checkNetworks()
    code, body, headers = hs.http.get("https://www.baidu.com", nil)
    if (code >= 200 and code < 300) then return true
    else return false end
end 