local utils = {
  get_node_rows = function(node)
    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, erow, ecol = node:range()
    return vim.api.nvim_buf_get_text(buf, srow, scol, erow, ecol, {})
  end,

  get_node_indentation = function(node)
    local buf = vim.api.nvim_get_current_buf()
    local srow, scol, _, _ = node:range()
    return vim.api.nvim_buf_get_text(buf, srow, 0, srow, scol, {})[1]
  end,

  node_line_count = function(node)
    local srow, _, erow, _ = node:range()
    return erow - srow + 1
  end,

  node_children_by_name = function(name, node)
    local result = {}

    for child, field in node:iter_children() do
      if field == name then
        result[#result + 1] = child
      end
    end
    return result
  end
}

return utils
