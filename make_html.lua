local json = require("json")

local function fail(message)
  io.stderr:write(message)
  os.exit(1)
end

if not arg[1] then
  fail("Error: No json target supplied.\n")
end

local function read_file(path)
  local handle = io.open(path, "rb")
  if not handle then
    return nil
  end

  local content = handle:read("*a")
  handle:close()
  return content
end

if not read_file(arg[1]) then
  fail("Error: json target `" .. arg[1] .. "` does not exist.\n")
end

local function parse_order_tree(source)
  local index = 1
  local length = #source

  local function decode_error(message)
    error(message .. " at byte " .. tostring(index))
  end

  local function skip_space()
    while index <= length do
      local char = source:sub(index, index)
      if char ~= " " and char ~= "\t" and char ~= "\r" and char ~= "\n" then
        return
      end
      index = index + 1
    end
  end

  local function parse_string()
    if source:sub(index, index) ~= '"' then
      decode_error("expected string")
    end

    index = index + 1
    local result = {}

    while index <= length do
      local char = source:sub(index, index)
      if char == '"' then
        index = index + 1
        return table.concat(result)
      end

      if char == "\\" then
        local escaped = source:sub(index + 1, index + 1)
        if escaped == "u" then
          local hex = source:sub(index + 2, index + 5)
          local codepoint = tonumber(hex, 16)
          if not codepoint then
            decode_error("invalid unicode escape")
          end

          if codepoint <= 0x7F then
            result[#result + 1] = string.char(codepoint)
          elseif codepoint <= 0x7FF then
            result[#result + 1] = string.char(
              math.floor(codepoint / 64) + 192,
              (codepoint % 64) + 128
            )
          else
            result[#result + 1] = string.char(
              math.floor(codepoint / 4096) + 224,
              math.floor((codepoint % 4096) / 64) + 128,
              (codepoint % 64) + 128
            )
          end

          index = index + 6
        else
          local replacements = {
            ["\""] = '"',
            ["\\"] = "\\",
            ["/"] = "/",
            ["b"] = "\b",
            ["f"] = "\f",
            ["n"] = "\n",
            ["r"] = "\r",
            ["t"] = "\t",
          }

          if replacements[escaped] == nil then
            decode_error("invalid escape sequence")
          end

          result[#result + 1] = replacements[escaped]
          index = index + 2
        end
      else
        result[#result + 1] = char
        index = index + 1
      end
    end

    decode_error("unterminated string")
  end

  local parse_value

  local function parse_number()
    local start_index = index
    local char = source:sub(index, index)
    if char == "-" then
      index = index + 1
    end

    while index <= length and source:sub(index, index):match("%d") do
      index = index + 1
    end

    if source:sub(index, index) == "." then
      index = index + 1
      while index <= length and source:sub(index, index):match("%d") do
        index = index + 1
      end
    end

    char = source:sub(index, index)
    if char == "e" or char == "E" then
      index = index + 1
      char = source:sub(index, index)
      if char == "+" or char == "-" then
        index = index + 1
      end
      while index <= length and source:sub(index, index):match("%d") do
        index = index + 1
      end
    end

    return { kind = "scalar", raw = source:sub(start_index, index - 1) }
  end

  local function parse_literal(expected)
    if source:sub(index, index + #expected - 1) ~= expected then
      decode_error("expected " .. expected)
    end
    index = index + #expected
    return { kind = "scalar", raw = expected }
  end

  local function parse_array()
    local node = { kind = "array", items = {} }
    index = index + 1
    skip_space()

    if source:sub(index, index) == "]" then
      index = index + 1
      return node
    end

    while true do
      node.items[#node.items + 1] = parse_value()
      skip_space()

      local char = source:sub(index, index)
      if char == "]" then
        index = index + 1
        return node
      end
      if char ~= "," then
        decode_error("expected ',' or ']' in array")
      end

      index = index + 1
      skip_space()
    end
  end

  local function parse_object()
    local node = { kind = "object", keys = {}, children = {} }
    index = index + 1
    skip_space()

    if source:sub(index, index) == "}" then
      index = index + 1
      return node
    end

    while true do
      local key = parse_string()
      skip_space()
      if source:sub(index, index) ~= ":" then
        decode_error("expected ':' after object key")
      end

      index = index + 1
      skip_space()

      node.keys[#node.keys + 1] = key
      node.children[key] = parse_value()

      skip_space()

      local char = source:sub(index, index)
      if char == "}" then
        index = index + 1
        return node
      end
      if char ~= "," then
        decode_error("expected ',' or '}' in object")
      end

      index = index + 1
      skip_space()
    end
  end

  parse_value = function()
    skip_space()

    local char = source:sub(index, index)
    if char == "{" then
      return parse_object()
    end
    if char == "[" then
      return parse_array()
    end
    if char == '"' then
      parse_string()
      return { kind = "scalar" }
    end
    if char == "-" or char:match("%d") then
      return parse_number()
    end
    if char == "t" then
      return parse_literal("true")
    end
    if char == "f" then
      return parse_literal("false")
    end
    if char == "n" then
      return parse_literal("null")
    end

    decode_error("unexpected character '" .. char .. "'")
  end

  local tree = parse_value()
  skip_space()
  if index <= length then
    decode_error("trailing data")
  end

  return tree
end

local function load_json(path)
  local source = read_file(path)
  return json.decode(source), parse_order_tree(source)
end

local data, data_order = load_json(arg[1])
local shared, shared_order = load_json("shared.json")

local function read_command(command)
  local handle = io.popen(command)
  if not handle then
    return ""
  end

  local output = handle:read("*a") or ""
  handle:close()
  return output
end

local git_info = read_command("git log --pretty=format:'%aD [git:%h]' -n 1")

local lines = {}

local function emit(line)
  lines[#lines + 1] = line
end

emit("<!DOCTYPE html>")
emit("<html>")
emit("  <head>")
emit("    <title>" .. shared.name .. "'s R&eacute;sum&eacute;</title>")
emit("    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">")
emit("    <link rel=\"stylesheet\" href=\"style.css\" type=\"text/css\" />")
emit("  </head>")
emit("  <body>")
emit("    <div id=\"pagewrap\">")
emit("      <div id=\"github\">Rendered from http://github.com/josefnpat/resume<br \\>" .. git_info .. "</div>")
emit("      <div id=\"monster\"></div>")
emit("      <div id=\"sidebar\">")
emit("        <div id=\"name\">" .. shared.name .. "</div>")
emit("        <div id=\"contacts\">")

for _, contact_key in ipairs(shared_order.children.contact.keys) do
  local contact = shared.contact[contact_key]
  emit("          <div class=\"contact\">")
  emit("            <ul>")
  emit("              <li>" .. contact_key .. "</li>")
  for _, line in ipairs(contact) do
    emit("              <li class=\"contactvalue\">" .. line .. "</li>")
  end
  emit("            </ul>")
  emit("          </div> <!-- end contact -->")
end

emit("        </div> <!-- end contacts -->")
emit("      </div> <!-- end sidebar -->")
emit("      <div id=\"sections\">")

for _, section_name in ipairs(data_order.children.sections.keys) do
  local section = data.sections[section_name]
  local section_order = data_order.children.sections.children[section_name]

  emit("        <div class=\"section\"> <!-- Section: " .. section_name .. " -->")
  emit("          <div class=\"title\">" .. section_name .. "</div>")

  if section.Header ~= nil then
    emit("          <div class=\"header\">" .. section.Header .. "</div>")
  end

  if section.Paragraph ~= nil then
    for _, paragraph in ipairs(section.Paragraph) do
      emit("          <div class=\"paragraph\">" .. paragraph .. "</div>")
    end
  end

  if section.Table ~= nil then
    emit("          <table>")
    for _, row_key in ipairs(section_order.children.Table.keys) do
      emit("            <tr>")
      emit("              <td class=\"l\">" .. row_key .. "</td>")
      emit("              <td class=\"r\">" .. section.Table[row_key] .. "</td>")
      emit("            </tr>")
    end
    emit("          </table>")
  end

  if section.Timeline ~= nil then
    emit("          <div class=\"timeline\">")
    for _, time_key in ipairs(section_order.children.Timeline.keys) do
      if time_key:sub(1, 9) ~= "disabled:" then
        local time_value = section.Timeline[time_key]
        emit("              <div class=\"time\">")
        emit("                <div class=\"key\">" .. time_key .. "</div>")
        if type(time_value) == "table" then
          for _, value in ipairs(time_value) do
            emit("                    <div class=\"value\">" .. value .. "</div>")
          end
        else
          emit("                  <div class=\"value\">" .. time_value .. "</div>")
        end
        emit("              </div> <!-- end time -->")
      end
    end
    emit("          </div> <!-- end timeline -->")
  end

  emit("        </div> <!-- end section -->")
end

emit("      </div> <!-- end sections -->")
emit("    </div> <!-- end pagewrap -->")
emit("  </body>")
emit("</html>")

io.write(table.concat(lines, "\n"))
io.write("\n")