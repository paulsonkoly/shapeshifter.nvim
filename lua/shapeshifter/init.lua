local ts_utils = require("nvim-treesitter.ts_utils")
local m = {}

--[[
grab curr pos -> ts_node -> walk upwards until 1 match -> execute corresponding
action.
--]]

local endless_method = require("shapeshifter.shifters.endless_method")
local method = require("shapeshifter.shifters.method")
local single_body_condition = require("shapeshifter.shifters.single_body_condition")

m.shifters = { endless_method, method, single_body_condition }

m.shiftshapes = function()
  for _, shifter in ipairs(m.shifters) do
    local current_node = ts_utils.get_node_at_cursor()

    while current_node do
      local data = shifter.match(current_node)
      if data then
        shifter.shift(data)
        return
      end
      current_node = current_node:parent()
    end
    print("no shapeshifter found a match :(")
  end
end

return m
