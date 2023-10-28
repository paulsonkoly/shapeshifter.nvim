local utils = require("shapeshifter.utils")

--[[ def foo(a,                           def foo(a, b = 13)
--           b = 13)                         @
       @x                      ->         end
     end
--]]
local single_line_arguments = {
  match = function(current_node)
    if current_node:type() == "argument_list" then
      local arguments = {}

      -- otherwise multiline params
      if utils.node_line_count(current_node) > 1 then
        return nil
      end

      for parameter, _ in current_node:iter_children(current_node) do
        if parameter:named() then
          arguments[#arguments + 1] = parameter
        end
      end

      return { target = current_node, arguments = arguments }
    end
  end,

  shift = function(data)
    local node, arguments = data.target, data.arguments
    local _, indent_column, _, _ = node:range()
    local indent = (' '):rep(indent_column + 1)

    local replacement = { }
    for ix, parameter in ipairs(arguments) do
      local parameter_text = utils.node_rows(parameter)[1]

      local line = ix == 1 and "(" or indent .. ""
      line = line .. parameter_text
      line = line .. (ix < #arguments and "," or ")")

      replacement[#replacement+1] = line
    end

    utils.node_replace_with_lines(node, replacement)
  end
}

return single_line_arguments
