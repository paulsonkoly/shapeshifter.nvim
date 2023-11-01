local sh = require("shapeshifter")
local buf_set_content = require("shapeshifter.utils").buf_set_content

describe("single line arguments", function()
  vim.cmd("set filetype=ruby")

  describe("with a method call with arguments on a single line", function()
    local lines = { "foo(a, b, c)" }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, { 1, 5 })

    it("rewrites the call to multi line", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same({
        "foo(a,",
        "    b,",
        "    c)"
      }, result)
    end)
  end)

  describe("with a single argument", function()
    local lines = { "foo v" }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, { 1, 4 })

    it("does not do the rewrite", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(lines, result)
    end)
  end)

  describe("with a comment after the argument list", function()
    local lines = { "foo(a, b, c) # boo!" }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, { 1, 5 })

    it("puts the comment after the call", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same({
        "foo(a,",
        "    b,",
        "    c) # boo!" },
        result)
    end)
  end)
end)
