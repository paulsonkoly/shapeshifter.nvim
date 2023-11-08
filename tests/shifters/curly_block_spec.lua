local sh = require("shapeshifter")
local buf_set_content = require("shapeshifter.utils").buf_set_content

describe("curly block shifter", function()
  vim.cmd("set filetype=ruby")

  describe("with a single line curly block", function()
    local lines = {
      "[1, 2, 3].each { |v| puts v }"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, {1, 16})

    it("rewrites the block to be multi line", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(
        {
          "[1, 2, 3].each do |v|",
          "  puts v",
          "end"
        }, result)
    end)
  end)

  describe("with a comment at the end of line", function()
    local lines = {
      "[1, 2, 3].each { |v| puts v } # boo!"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, {1, 16})

    it("puts the comment after the block", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(
        {
          "[1, 2, 3].each do |v|",
          "  puts v",
          "end # boo!"
        }, result)
    end)
  end)
end)
