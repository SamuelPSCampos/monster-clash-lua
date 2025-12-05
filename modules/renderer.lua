local utils = require("modules.utils")
local bestiary = require("modules.bestiary")

local renderer = {}

------------------------------------------------------------
-- createBar
------------------------------------------------------------

local fullBlock <const> = "#"
local emptyBlock <const> = "."
local baseBlock <const> = 10

--- Creates a stat progress bar using filled/empty blocks.
---
--- @param value number Current value.
--- @param maxValue number Maximum value.
--- @return string
function renderer.createBar(value, maxValue)
    local filled = math.floor(value / maxValue * baseBlock)
    return fullBlock:rep(filled) .. emptyBlock:rep(baseBlock - filled)
end

------------------------------------------------------------
-- formatStatLine
------------------------------------------------------------

--- Formats a single stat line, including a label and a progress bar.
--- Requires a configuration table.
---
--- @param opts { label: string, attribute: number, maxAttribute?: number }
--- @return string
function renderer.formatStatLine(opts)
    utils.expect({ name = "formatStatLine.opts", value = opts, expected = "table" })
    utils.expect({ name = "formatStatLine.label", value = opts.label, expected = "string" })
    utils.expect({ name = "formatStatLine.attribute", value = opts.attribute, expected = "number" })

    if opts.maxAttribute ~= nil then
        utils.expect({ name = "formatStatLine.maxAttribute", value = opts.maxAttribute, expected = "number" })
    end

    local maxAttribute = opts.maxAttribute or bestiary.baseAttribute

    return string.format("%-10s %s", opts.label, renderer.createBar(opts.attribute, maxAttribute))
end

------------------------------------------------------------
-- monsterSheet
------------------------------------------------------------

--- Builds and returns a formatted monster sheet containing:
--- - header
--- - ASCII representation
--- - description
--- - stat list with bars
---
--- @param opts { name: string, info: table, maxAttribute?: number }
--- @return string
function renderer.monsterSheet(opts)
    utils.expect({ name = "monsterSheet.opts", value = opts, expected = "table" })
    utils.expect({ name = "monsterSheet.name", value = opts.name, expected = "string" })
    utils.expect({ name = "monsterSheet.info", value = opts.info, expected = "table" })

    local name = opts.name
    local info = opts.info
    local statMaxAttribute = opts.maxAttribute or bestiary.baseAttribute

    local lines = utils.newBuffer()

    lines:extend({
        utils.separators[1],
        "   " .. name,

        utils.indentLines(info.representation, 4),

        utils.separators[2],
        info.description,
        utils.separators[2],

        "STATS",
    })

    for _, meta in ipairs(bestiary.statsMeta) do
        local statLabel = meta.label .. ":"
        local statAttribute = info.stats[meta.stat]

        if not statAttribute then
            error("Stat '" .. meta.stat .. "' missing for monster '" .. name .. "'")
        end

        lines:add(renderer.formatStatLine({
            label = statLabel,
            attribute = statAttribute,
            maxAttribute = statMaxAttribute,
        }))
    end

    local lineBlock = table.concat(lines, "\n")
    return utils.addBorder(lineBlock)
end

return renderer
