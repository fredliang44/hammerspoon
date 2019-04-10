print('==================================================')
require "modules/hotkey"
require "modules/screens"
require "modules/windows"
require "modules/launch"
require "modules/system"
require "modules/wifi"
require "modules/auto_reload"
require "modules/weather"

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end