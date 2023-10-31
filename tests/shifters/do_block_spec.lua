local sh = require("shapeshifter")
local buf_set_content = require("shapeshifter.utils").buf_set_content

describe("do block shifter", function()
  vim.cmd("set filetype=ruby")

  describe("with a single line body do block", function()
    local lines = {
      "[1, 2, 3].each do |v|",
      "  puts v",
      "end"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, {1, 16})

    it("rewrites the block to single line", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(
        {
          "[1, 2, 3].each { |v| puts v }"
        }, result)
    end)
  end)

  describe("with a multi line body do block", function()
    local lines = {
      "[1,2,3].each do |v|",
      "  puts 'I will output the array element'",
      "  puts v",
      "end"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, {1, 16})

    it("does not do the rewrite", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same( lines , result)
    end)
  end)


  describe("with a comment after the block arguments", function()
    local lines = {
      "[1, 2, 3].each do |v| # will this work?",
      "  puts v",
      "end"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, {1, 16})

    it("does not do the rewrite", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same( lines , result)
    end)
  end)

  describe("with a comment on the body", function()
    local lines = {
      "[1, 2, 3].each do |v|",
      "  puts v # I know what I'm doing",
      "end"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, {1, 16})

    it("does not do the rewrite", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same( lines , result)
    end)
  end)
end)
