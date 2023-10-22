local m = {}

--[[
grab curr pos -> ts_node -> walk upwards until 1 match -> execute corresponding
action.
--]]

local endless_method = require("shapeshifter.shifters.endless_method")
local method = require("shapeshifter.shifters.method")

m.shifters = { endless_method, method }

m.shiftshapes = function()
  for _, shifter in ipairs(m.shifters) do
    local node = shifter.match()
    if node ~= nil then
      shifter.shift(node)
      return
    end
  end
  print("no shapeshifter found a match :(")
end

return m
