local utils = require("shapeshifter.utils")

--[[ foo(a, b = 13) do |v|
       puts v                      ->         foo(a, b = 13) { |v| puts v }
     end
--]]
local do_block = {
  match = function(current_node)
    if current_node:type() == "do_block" then
      local parameters = utils.node_children_by_name("parameters", current_node)[1]
      local body = utils.node_children_by_name("body", current_node)[1]
      local comments = utils.node_get_descendants_by_type(current_node, "comment")
      local has_comments = #comments > 0

      if (not has_comments and utils.node_line_count(body) == 1) then
        return { target = current_node, parameters = parameters, body = body }
      end
    end
  end,

  shift = function(data)
    local node, parameters, body = data.target, data.parameters, data.body

    local line = "{ "
    if parameters then
      line = line .. utils.node_rows(parameters)[1] .. " "
    end
    line = line .. utils.node_rows(body)[1]
    line = line .. " }"

    utils.node_replace_with_lines(node, { line })
  end
}

return do_block
