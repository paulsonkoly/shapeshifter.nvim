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
  end
}

return utils
