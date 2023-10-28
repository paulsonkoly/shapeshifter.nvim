local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("shapeshifter.utils")

--[[ def foo(a, b = 13)
       @x                      ->         def foo(a, b = 13) = @x
     end
--]]
local method = {
  match = function(current_node)
    if current_node:type() == "method" then
      local name = utils.node_children_by_name("name", current_node)[1]
      local parameters = utils.node_children_by_name("parameters", current_node)[1]
      local body = utils.node_children_by_name("body", current_node)[1]

      -- otherwise indistinguishable from endless method
      local c_start, _, _ = current_node:start()
      local b_start, _, _ = body:start()

      if (c_start ~= b_start and
            (not parameters or utils.node_line_count(parameters) == 1) and
            utils.node_line_count(body) == 1) then
        return {
          target = current_node,
          name = name,
          parameters = parameters,
          body = body
        }
      end
    end
  end,

  shift = function(data)
    local node, name, parameters, body = data.target,
        data.name, data.parameters, data.body

    local header = "def " .. utils.get_node_rows(name)[1]
    if parameters then
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
