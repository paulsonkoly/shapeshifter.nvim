local ts_utils = require("nvim-treesitter.ts_utils")
local m = {}

local endless_method = require("shapeshifter.shifters.ruby.endless_method")
local method = require("shapeshifter.shifters.ruby.method")
local single_body_condition = require("shapeshifter.shifters.ruby.single_body_condition")
local postfix_condition = require("shapeshifter.shifters.ruby.postfix_condition")
local do_block = require("shapeshifter.shifters.ruby.do_block")
local curly_block = require("shapeshifter.shifters.ruby.curly_block")
local multi_line_arguments = require("shapeshifter.shifters.ruby.multi_line_arguments")
local single_line_arguments = require("shapeshifter.shifters.ruby.single_line_arguments")

-- order matters, smaller node should come first
m.shifters = {
  ruby = {
    multi_line_arguments,
    single_line_arguments,
    endless_method,
    method,
    single_body_condition,
    postfix_condition,
    do_block,
    curly_block
  }
}

m.shiftshapes = function()
  local filetype = vim.bo.filetype
  local shifters = m.shifters[filetype]

  if shifters then
    for _, shifter in ipairs(shifters) do
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
  end

  print("no shapeshifter found a match :(")
end

return m
