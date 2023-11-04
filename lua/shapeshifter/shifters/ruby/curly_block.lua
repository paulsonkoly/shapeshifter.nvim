local utils = require("shapeshifter.utils")

--[[ foo(a, b = 13) do |v|
       puts v                      ->         foo(a, b = 13) { |v| puts v }
     end
--]]
local do_block = {
  match = function(current_node)
    if current_node:type() == "block" then
      local parameters = utils.node_children_by_name("parameters", current_node)[1]
      local body = utils.node_children_by_name("body", current_node)[1]

      return { target = current_node, parameters = parameters, body = body }
    end
  end,

  shift = function(data)
    local node, parameters, body = data.target, data.parameters, data.body
    local indent = utils.node_indentation(node)

    local replacement = {}
    local header = "do"
    if parameters then
      header = header .. " " .. utils.node_rows(parameters)[1]
    end
    replacement = { header }
    for _, row in ipairs(utils.node_rows(body)) do
      replacement[#replacement + 1] = indent .. "  " .. row
    end
    replacement[#replacement + 1] = indent .. "end"

    utils.node_replace_with_lines(node, replacement)
  end
}

return do_block
