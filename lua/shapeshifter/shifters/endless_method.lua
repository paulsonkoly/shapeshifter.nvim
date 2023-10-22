local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("shapeshifter.utils")

--[[                                     def foo(a, b = 13)
  def foo(a, b = 13) = @x       ->         @x
                                         end
--]]
local endless_method = {
  match = function()
    local current_node = ts_utils.get_node_at_cursor()
    while current_node ~= nil do
      if current_node:type() == "method" then
        local srow, _, erow, _ = current_node:range()
        if srow == erow then
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
    local indent = utils.get_node_indentation(node)
    if parameters ~= nil then
      -- TODO : multiline parameters
      header = header .. utils.get_node_rows(parameters)[1]
    end

    local replacement = { header }

    for _, row in ipairs(utils.get_node_rows(body)) do
      -- TODO what if indentation is not 2 spaces?
      replacement[#replacement+1] = indent .. "  " .. row
    end

    replacement[#replacement+1] = indent .. "end"

    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol = node:range()
    vim.api.nvim_buf_set_text(buf, srow, scol, erow, ecol, replacement)
  end
}

return endless_method
