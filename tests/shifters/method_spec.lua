local sh = require("shapeshifter")

describe("method shifter", function()
  vim.cmd("set filetype=ruby")

  after_each(function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  end)

  describe("with a simple one line method", function()
    local lines = {
      "def method(a, b = 13, c: 'foo', &block)",
      "  puts a + b",
      "end"
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    it("rewrites the method to be endless", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.equal(#result, 1)
      assert.equal(result[1], "def method(a, b = 13, c: 'foo', &block) = puts a + b")
    end)
  end)

  describe("with a method that spans multiple lines", function()
    local lines = {
      "def method(a, b = 13, c: 'foo', &block)",
      "  puts a + b",
      "  block.call(c)",
      "  return 13",
      "end"
    }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    it("does not rewrite the method", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(lines, result)
    end)
  end)
end)
