local ts_utils = require("nvim-treesitter.ts_utils")
local utils = require("shapeshifter.utils")

--[[
  if condition
    do_something        -->       do_something if condition
  end
--]]
local single_body_condition = {
  match = function(current_node)
    if current_node:type() == "if" or current_node:type() == "unless" then
      local condition = utils.node_children_by_name("condition", current_node)
      local consequence = utils.node_children_by_name("consequence", current_node)
      local alternative = utils.node_children_by_name("alternative", current_node)

      if #condition == 1 and #consequence == 1 and #alternative == 0 then
        if consequence[1]:child_count() == 1 then
          local consequence_body = consequence[1]:child(0)

          if (utils.node_line_count(condition[1]) == 1 and
                utils.node_line_count(consequence_body) == 1) then
            return {
              target = current_node,
              condition = condition[1],
              consequence = consequence_body
            }
          end
        end
      end
    end
  end,

  shift = function(data)
    local node, condition, consequence =
        data.target, data.condition, data.consequence

    local replacement =
        utils.get_node_rows(consequence)[1] .. " "
        .. node:type() .. " "
        .. utils.get_node_rows(condition)[1]

    replacement = { replacement }

    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol = node:range()
    vim.api.nvim_buf_set_text(buf, srow, scol, erow, ecol, replacement)
  end
}

return single_body_condition
