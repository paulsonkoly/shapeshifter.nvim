local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("shapeshifter.utils")

--[[ def foo(a, b = 13)
       @x                      ->         def foo(a, b = 13) = @x 
     end
--]]
local method = {
  match = function()
    local current_node = ts_utils.get_node_at_cursor()
    while current_node ~= nil do
      if current_node:type() == "method" then
        local srow, _, erow, _ = current_node:range()
        -- TODO probably better to check that body is 1 line
        if srow + 2 == erow then
          return current_node
        end
      end
      current_node = current_node:parent()
    end
    return nil
  end,

  shift = function(node)
    local name, parameters, body = nil, nil, nil

    for child, field in node:iter_children() do
      if child ~= nil then
        if child:type() == 'identifier' and field == 'name' then
          name = child
        elseif child:type() == 'method_parameters' and field == 'parameters' then
          parameters = child
        elseif field == 'body' then
          body = child
        end
      end
    end

    if name == nil or body == nil then
      print("method name or body not found")
      return
    end

    local header = "def " .. utils.get_node_rows(name)[1]
    if parameters ~= nil then
      -- TODO : multiline parameters
      header = header .. utils.get_node_rows(parameters)[1]
    end

    header = header .. " = "

    header = header .. utils.get_node_rows(body)[1]

    local replacement = { header }

    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol = node:range()
    vim.api.nvim_buf_set_text(buf, srow, scol, erow, ecol, replacement)
  end
}

return method
