local sh = require("shapeshifter")
local buf_set_content = require("shapeshifter.utils").buf_set_content

describe("endless method shifter", function()
  vim.cmd("set filetype=ruby")

  describe("with an endless method", function()
    local lines = {
      "def method(a, b = 13, c: 'foo', &block) = puts a + b",
    }
    buf_set_content(lines)

    it("rewrites the method to be multi line", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.equal(#result, 3)
      assert.same(
        {
          "def method(a, b = 13, c: 'foo', &block)",
          "  puts a + b",
          "end"
        }, result)
    end)
  end)

  describe("with a comment at the end of line", function()
    local lines = {
      "def method = puts('boo!') # yay !"
    }
    buf_set_content(lines)

    it("puts the comment after the method", function()
      sh.shiftshapes()

      local result = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      assert.same(
        {
          "def method",
          "  puts('boo!')",
          "end # yay !",
        }, result
      )
    end)
  end)
end)
