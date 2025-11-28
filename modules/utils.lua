local utils = {}

utils.separator1 = "=========================================================================================="
utils.separator2 = "------------------------------------------------------------------------------------------"

local fullBlock = "#"
local emptyBlock = "."
local baseBlock = 10
function utils.createBar(value, maxValue)
    local filled = math.floor(value / maxValue * baseBlock)
    return fullBlock:rep(filled) .. emptyBlock:rep(baseBlock - filled)
end

local noBorderPadding = {
    [utils.separator1] = true,
    [utils.separator2] = true,
}
utils.defaultBorder = "|"
function utils.addBorder(text, border)
    border = border or utils.defaultBorder
    local result = {}

    for line in text:gmatch("([^\n]*)\n?") do
        if noBorderPadding[line] then
            result[#result + 1] = border .. line
        else
            result[#result + 1] = border .. " " .. line
        end
    end

    return table.concat(result, "\n")
end

function utils.newBuffer()
    local buffer = {}
    local visited = setmetatable({}, { __mode = "k" })

    local function add(value, unpackTable)
        if unpackTable and type(value) == "table" then
            if visited[value] then
                return
            end
            visited[value] = true

            for _, item in ipairs(value) do
                add(item, unpackTable)
            end
            return
        end

        buffer[#buffer + 1] = value
    end

    return buffer, add
end

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

function utils.indentLines(art, indentation)
    indentation = indentation or ""
    local result = {}

    for line in art:gmatch("([^\n]*)\n?") do
        result[#result + 1] = indentation .. line
    end

    return result
end

function utils.customIoRead(symbol, type, border)
    symbol = (symbol or ">") .. " "
    type = type or "*l"
    border = border or utils.defaultBorder
    io.write(utils.addBorder(symbol, border))
    local input = io.read(type)
    return input
end

function utils.alignLeft(text)
    local lines = {}
    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(lines, line)
    end

    local minIndent = math.huge
    for _, line in ipairs(lines) do
        local firstChar = line:find("%S")
        if firstChar then
            minIndent = math.min(minIndent, firstChar - 1)
        end
    end

    if minIndent == math.huge or minIndent == 0 then
        return text
    end

    for i, line in ipairs(lines) do
        local firstChar = line:find("%S")
        if firstChar then
            lines[i] = line:sub(minIndent + 1)
        end
    end

    return table.concat(lines, "\n")
end

function utils.formatActions(actions, symbol)
    symbol = symbol or ")"
    local lines = {}

    for i, action in ipairs(actions) do
        if type(action) == "table" then
            local label = action.label or "label"

            lines[#lines + 1] = string.format("%d" .. symbol .. " %s", i, label)
        end
    end

    return table.concat(lines, "\n")
end

return utils
