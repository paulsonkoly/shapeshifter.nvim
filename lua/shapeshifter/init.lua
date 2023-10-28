local ts_utils = require("nvim-treesitter.ts_utils")
local m = {}

--[[
grab curr pos -> ts_node -> walk upwards until 1 match -> execute corresponding
action.
--]]

local endless_method = require("shapeshifter.shifters.endless_method")
local method = require("shapeshifter.shifters.method")
local single_body_condition = require("shapeshifter.shifters.single_body_condition")
local postfix_condition = require("shapeshifter.shifters.postfix_condition")
local do_block = require("shapeshifter.shifters.do_block")
local curly_block = require("shapeshifter.shifters.curly_block")
local multi_line_arguments = require("shapeshifter.shifters.multi_line_arguments")
local single_line_arguments = require("shapeshifter.shifters.single_line_arguments")

m.shifters = {
  -- order matters, smaller node should come first
  multi_line_arguments,
  single_line_arguments,
  endless_method,
  method,
  single_body_condition,
  postfix_condition,
  do_block,
  curly_block
}

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
  end

  print("no shapeshifter found a match :(")
end

return m
