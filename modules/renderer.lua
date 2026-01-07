local Utils = require("modules.utils")
local Bestiary = require("modules.bestiary")

local Renderer = {}

------------------------------------------------------------
-- statsMeta
------------------------------------------------------------

--- Defines the list of stats rendered in the status panel.
--- Each entry maps an internal stat name to its display label.
---
--- @type { stat: string, label: string }[]
Renderer.statsMeta = {
    { stat = "damage",       label = "DMG" },
    { stat = "health",       label = "HP" },
    { stat = "intelligence", label = "INT" },
    { stat = "defense",      label = "DEF" },
    { stat = "speed",        label = "SPD" },
    { stat = "critical",     label = "CRIT" },
}

------------------------------------------------------------
-- createBar
------------------------------------------------------------

local FULL_CHAR <const> = "#"
local EMPTY_CHAR <const> = "."
local BASE_BAR_LENGTH <const> = 20

--- Creates a stat progress bar using filled/empty blocks.
---
--- @param value number Current value.
--- @param maxValue number Maximum value.
--- @return string
function Renderer.createBar(value, maxValue)
    local rawRatio = value / maxValue
    local visualRatio = math.max(0, math.min(1, rawRatio))

    local filled = math.floor(visualRatio * BASE_BAR_LENGTH)
    if value > 0 and filled <= 0 then filled = 1 end
    if value < 0 then value = 0 end

    local bar = FULL_CHAR:rep(filled) .. EMPTY_CHAR:rep(BASE_BAR_LENGTH - filled)

    return string.format(
        "%s %3d",
        bar, math.floor(value))
end

------------------------------------------------------------
-- formatStatLine
------------------------------------------------------------

--- Formats a single stat line, including a label and a progress bar.
--- Requires a configuration table.
---
--- @param opts { label: string, attribute: number, maxAttribute?: number }
--- @return string
function Renderer.formatStatLine(opts)
    Utils.expect({ name = "formatStatLine.opts", value = opts, expected = "table" })
    Utils.expect({ name = "formatStatLine.label", value = opts.label, expected = "string" })
    Utils.expect({ name = "formatStatLine.attribute", value = opts.attribute, expected = "number" })

    if opts.maxAttribute ~= nil then
        Utils.expect({ name = "formatStatLine.maxAttribute", value = opts.maxAttribute, expected = "number" })
    end

    local maxAttribute = opts.maxAttribute or Bestiary.baseAttribute

    return string.format(
        "%-5s %s",
        opts.label, Renderer.createBar(opts.attribute, maxAttribute)
    )
end

------------------------------------------------------------
-- entitySheet
------------------------------------------------------------

--- Builds and returns a formatted entity sheet containing:
--- - header
--- - ASCII representation
--- - description
--- - stat list with bars
---
--- @param opts { info: table, maxAttribute?: number }
--- @return string
function Renderer.entitySheet(opts)
    Utils.expect({ name = "entitySheet.opts", value = opts, expected = "table" })
    Utils.expect({ name = "entitySheet.info", value = opts.info, expected = "table" })

    local info = opts.info
    local name = info.name
    local statMaxAttribute = opts.maxAttribute or Bestiary.baseAttribute

    local lines = Utils.newBuffer()

    lines:extend({
        Utils.separators[1],
        "   " .. name,

        Utils.indentLines(info.representation, 4),

        Utils.separators[2],
        info.description,
        Utils.separators[2],

        "STATS",
    })

    for _, meta in ipairs(Renderer.statsMeta) do
        local statLabel = meta.label .. ":"
        local statAttribute = info.stats[meta.stat]

        if statAttribute then
            lines:add(Renderer.formatStatLine({
                label = statLabel,
                attribute = statAttribute,
                maxAttribute = statMaxAttribute,
            }))
        end
    end

    local lineBlock = table.concat(lines, "\n")
    return Utils.addBorder(lineBlock)
end

return Renderer
