local utils = require("shapeshifter.utils")

--[[ def foo(a,                           def foo(a, b = 13)
--           b = 13)                         @
       @x                      ->         end
     end
--]]
local multi_line_parameters = {
  match = function(current_node)
    if current_node:type() == "argument_list" then
      local all_single_line_parameters = true
      local parameters = {}

      -- otherwise single line params
      if utils.node_line_count(current_node) <= 1 then
        return nil
      end

      for parameter, _ in current_node:iter_children(current_node) do
        if parameter:named() then
          all_single_line_parameters = all_single_line_parameters and
              utils.node_line_count(parameter) == 1
          parameters[#parameters + 1] = parameter
        end
      end

      if all_single_line_parameters then
        return { target = current_node, parameters = parameters }
      end
    end
  end,

  shift = function(data)
    local node, parameters = data.target, data.parameters

    local line = "("
    for ix, parameter in ipairs(parameters) do
      line = ix == 1 and line or line .. ", "
      line = line .. utils.node_rows(parameter)[1]
    end
    line = line .. ")"

    utils.node_replace_with_lines(node, { line })
  end
}

return multi_line_parameters
