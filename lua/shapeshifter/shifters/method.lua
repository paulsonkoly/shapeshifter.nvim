local utils = require("shapeshifter.utils")

--[[ def foo(a, b = 13)
       @x                      ->         def foo(a, b = 13) = @x
     end
--]]
local method = {
  match = function(current_node)
    if current_node:type() == "method" then
      local name = utils.node_children_by_name("name", current_node)[1]
      local parameters = utils.node_children_by_name("parameters", current_node)[1]
      local body = utils.node_children_by_name("body", current_node)[1]

      -- otherwise indistinguishable from endless method
      local c_start, _, _ = current_node:start()
      local b_start, _, _ = body:start()

      if (c_start ~= b_start and
            (not parameters or utils.node_line_count(parameters) == 1) and
            utils.node_line_count(body) == 1) then
        return {
          target = current_node,
          name = name,
          parameters = parameters,
          body = body
        }
      end
    end
  end,

  shift = function(data)
    local node, name, parameters, body = data.target,
        data.name, data.parameters, data.body

    local line = "def " .. utils.get_node_rows(name)[1]
    if parameters then
      line = line .. utils.get_node_rows(parameters)[1]
    end
    line = line .. " = "
    line = line .. utils.get_node_rows(body)[1]

    utils.node_replace_with_lines(node, { line })
  end
}

return method
