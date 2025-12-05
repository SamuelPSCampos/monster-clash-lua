local utils = {}

------------------------------------------------------------
-- separators
------------------------------------------------------------

local separatorLength <const> = 100

--- Predefined line separators (long horizontal rule variants).
utils.separators = {
    [1] = string.rep("=", separatorLength),
    [2] = string.rep("-", separatorLength),
}

------------------------------------------------------------
-- addBorder
------------------------------------------------------------

--- Adds a left border to each line of a multi-line string.
--- Optional argument may be:
--- - string: sets the border character
--- - nil: uses the default "|" border
--- @param text string
--- @param border string?
--- @return string
function utils.addBorder(text, border)
    border = border or "|"
    local result = {}

    for line in text:gmatch("([^\n]*)\n?") do
        local isSeparator = false

        for _, sep in ipairs(utils.separators) do
            if line == sep then
                isSeparator = true
                break
            end
        end

        if isSeparator then
            result[#result + 1] = border .. line
        else
            result[#result + 1] = border .. " " .. line
        end
    end

    return table.concat(result, "\n")
end

--- Creates a buffer object.
--- add(value) appends one value.
--- extend(list) recursively appends items from array-like tables,
--- avoiding cycles.
--- @return table Buffer object.
function utils.newBuffer()
    local buffer = {}
    local visited = setmetatable({}, { __mode = "k" })

    function buffer:add(value)
        self[#self + 1] = value
    end

    function buffer:extend(list)
        if visited[list] then return end
        visited[list] = true

        for _, item in pairs(list) do
            if type(item) == "table" then
                self:extend(item)
            else
                self:add(item)
            end
        end
    end

    return buffer
end

------------------------------------------------------------
-- deepCopy
------------------------------------------------------------

--- Deep-clones a table, keeping metatables and avoiding recursion loops.
--- @param obj table
--- @param seen table?
--- @return any
function utils.deepCopy(obj, seen)
    if type(obj) ~= "table" then return obj end
    if seen and seen[obj] then return seen[obj] end

    local s = seen or {}
    local res = {}
    s[obj] = res

    for k, v in pairs(obj) do
        res[utils.deepCopy(k, s)] = utils.deepCopy(v, s)
    end

    return setmetatable(res, getmetatable(obj))
end

------------------------------------------------------------
-- indentLines
------------------------------------------------------------

--- Adds indentation to every line of a multi-line string.
--- Supports:
--- - number: converted to N spaces
--- - string: applied directly
--- - nil: no indentation
--- @param lines string
--- @param indentation string|number|nil
--- @return string
function utils.indentLines(lines, indentation)
    if type(indentation) == "number" then
        indentation = string.rep(" ", indentation)
    end

    indentation = (type(indentation) == "string" and indentation) or ""

    local result = {}

    for line in lines:gmatch("([^\n]*)\n?") do
        result[#result + 1] = indentation .. line
    end

    return table.concat(result, "\n")
end

------------------------------------------------------------
-- customIoRead
------------------------------------------------------------

--- Reads input with optional prompt formatting.
--- @param opts? { symbol?: string, readType?: string, border?: string }
--- @return string
function utils.customIoRead(opts)
    opts = (type(opts) == "table" and opts) or {}

    local symbol = (opts.symbol or ">") .. " "
    local readType = opts.readType or "*l"
    local border = opts.border

    io.write(utils.addBorder(symbol, border))
    return io.read(readType)
end

------------------------------------------------------------
-- alignLeft
------------------------------------------------------------

--- Removes the smallest common indentation from all lines in a multi-line string.
--- @param text string
--- @return string
function utils.alignLeft(text)
    local lines = {}
    local firstChars = {}
    local count = 0

    for line in text:gmatch("([^\n]*)\n?") do
        count = count + 1
        lines[count] = line

        local firstChar = line:find("%S")
        firstChars[count] = firstChar
    end

    local minIndent = math.huge
    for i = 1, count do
        local fc = firstChars[i]
        if fc then
            local indent = fc - 1
            if indent < minIndent then
                minIndent = indent
            end
        end
    end

    if minIndent == math.huge or minIndent == 0 then
        return text
    end

    for i = 1, count do
        local fc = firstChars[i]
        if fc then
            lines[i] = lines[i]:sub(minIndent + 1)
        end
    end

    return table.concat(lines, "\n")
end

------------------------------------------------------------
-- formatActions
------------------------------------------------------------

--- Formats a numbered list of menu actions.
--- Each entry may contain a "label" field; fallback is "label".
--- @param actions table<number, table> alguma coisa
--- @param symbol string|nil Character placed after the index (default ")").
--- @return string
function utils.formatActions(actions, symbol)
    symbol = symbol or ")"
    local lines = {}

    for i, action in ipairs(actions) do
        if type(action) == "table" then
            lines[#lines + 1] = string.format("%d%s %s", i, symbol, action.label or "label")
        end
    end

    return table.concat(lines, "\n")
end

------------------------------------------------------------
-- showScreen
------------------------------------------------------------

--- Shows a multi-line screen by flattening the list, joining lines,
--- and printing it with an optional custom border.
--- @param list table List of strings or nested tables to display.
--- @param border string|nil Optional border symbol passed to addBorder.
function utils.showScreen(list, border)
    local buffer = utils.newBuffer()
    buffer:extend(list)
    local block = table.concat(buffer, "\n")
    print(utils.addBorder(block, border))
end

------------------------------------------------------------
-- expect
------------------------------------------------------------

--- @class ExpectOptions
--- @field name string
--- @field value any
--- @field expected string

--- Validates a value against an expected Lua type.
--- @param opts ExpectOptions Configuration table with validation settings.
function utils.expect(opts)
    if type(opts) ~= "table" then
        error("expect.opts: table with fields { name, value, expected } required", 2)
    end

    local name = opts.name
    local value = opts.value
    local expected = opts.expected

    if type(name) ~= "string" then
        error("expect.name: 'name' must be a string", 2)
    end

    if type(expected) ~= "string" then
        error("expect.expected: 'expected' must be a string", 2)
    end

    if type(value) ~= expected then
        error(string.format(
            "%s: expected %s, got %s",
            name, expected, type(value)
        ), 3)
    end
end

return utils
