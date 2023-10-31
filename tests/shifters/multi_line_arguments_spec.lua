local sh = require("shapeshifter")
local buf_set_content = require("shapeshifter.utils").buf_set_content

describe("multi line arguments", function()
  vim.cmd("set filetype=ruby")

  describe("with a method call with argument list spanning across multiple lines", function()
    local lines = {
      "foo(a,",
      "    b)"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, { 2, 0 })

    it("rewrites the call to single line", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same({ "foo(a, b)" }, result)
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


  describe("with a comment after any of the arguments", function()
    local lines = {
      "foo(a,",
      "    b, # oops",
      "    c)"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, { 2, 0 })

    it("does not do the rewrite", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(lines, result)
    end)
  end)

  describe("with a comment after the argument list", function()
    local lines = {
      "foo(a,",
      "    b,",
      "    c) # boo!"
    }
    buf_set_content(lines)
    vim.api.nvim_win_set_cursor(0, { 2, 0 })

    it("puts the comment after the call", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same({ "foo(a, b, c) # boo!" }, result)
    end)
  end)
end)
