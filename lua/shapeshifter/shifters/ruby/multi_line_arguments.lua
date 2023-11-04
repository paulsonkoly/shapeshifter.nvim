local utils = require("shapeshifter.utils")

--[[ foo(a,                     ->                   foo(a, b)
--       b)
--]]
local multi_line_arguments = {
  match = function(current_node)
    if current_node:type() == "argument_list" then
      local all_single_line_arguments = true
      local arguments = {}
      local comments = utils.node_get_descendants_by_type(current_node, "comment")

      -- otherwise single line arguments
      if utils.node_line_count(current_node) <= 1 or #comments > 0 then
        return nil
      end

      for parameter, _ in current_node:iter_children(current_node) do
        if parameter:named() then
          all_single_line_arguments = all_single_line_arguments and
              utils.node_line_count(parameter) == 1
          arguments[#arguments + 1] = parameter
        end
      end

      if all_single_line_arguments then
        return { target = current_node, arguments = arguments }
      end
    end
  end,

  shift = function(data)
    local node, arguments = data.target, data.arguments

    local line = "("
    for ix, parameter in ipairs(arguments) do
      line = ix == 1 and line or line .. ", "
      line = line .. utils.node_rows(parameter)[1]
    end
    line = line .. ")"

    utils.node_replace_with_lines(node, { line })
  end
}

return multi_line_arguments
