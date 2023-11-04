local utils = require("shapeshifter.utils")

--[[ foo(a, b)              -->                foo(a,
--                                                 b)
--]]
local single_line_arguments = {
  match = function(current_node)
    if current_node:type() == "argument_list" then
      local arguments = {}

      -- otherwise multiline arguments
      if utils.node_line_count(current_node) > 1 then
        return nil
      end

      for parameter, _ in current_node:iter_children(current_node) do
        if parameter:named() then
          arguments[#arguments + 1] = parameter
        end
      end
      if #arguments <= 1 then
        return nil
      end

      -- look up the full method call and rewrite that too, in order to avoid whitspace problems between
      -- the argument list and the method name
      local method_call = current_node:parent()

      if (method_call and method_call:type() == "call") then
        local method_name = utils.node_children_by_name("method", method_call)
        local block = utils.node_children_by_name("block", method_call)

        return { target = method_call, arguments = arguments, method_name = method_name[1], block = block[1] }
      end
    end
  end,

  shift = function(data)
    local node, arguments, method_name, block = data.target, data.arguments, data.method_name, data.block
    local _, _, _, indent_column = method_name:range()
    local indent = (' '):rep(indent_column + 1)

    local replacement = {}
    local line = utils.node_rows(method_name)[1]
    local block_lines = {}
    local block_header = ""
    if block then
      block_lines = utils.node_rows(block)
      block_header = " " .. block_lines[1]
    end

    for ix, parameter in ipairs(arguments) do
      local parameter_text = utils.node_rows(parameter)[1]

      line = ix == 1 and line .. "(" or indent
      line = line .. parameter_text
      line = line .. (ix < #arguments and "," or ")" .. block_header)

      replacement[#replacement + 1] = line
    end

    for ix, block_line in ipairs(block_lines) do
      if ix > 1 then
        replacement[#replacement + 1] = block_line
      end
    end

    utils.node_replace_with_lines(node, replacement)
  end
}

return single_line_arguments
