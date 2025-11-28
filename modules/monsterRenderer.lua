local utils = require("modules.utils")
local bestiary = require("modules.bestiary")

local renderer = {}

renderer.statsMeta = {
    { stat = "damage",  label = "Damage" },
    { stat = "health",  label = "Health" },
    { stat = "defense", label = "Defense" },
    { stat = "speed",   label = "Speed" },
}

renderer.order = {
    "Monster 1",
    "Monster 2",
    "Monster 3",
    "Monster 4",
}

function renderer.formatStatLine(maxStatLblsLen, label, attribute, maxAttribute)
    local statsFmt = "%-" .. maxStatLblsLen .. "s %s"
    return statsFmt:format(label, utils.createBar(attribute, maxAttribute))
end

function renderer.monsterSheet(monsterName, monsterInfo, maxAttribute)
    local lines, addLine = utils.newBuffer()

    addLine({
        -- header
        utils.separator1,
        "   " .. monsterName,

        -- representation
        utils.indentLines(utils.alignLeft(monsterInfo.representation), "    "),

        -- description
        utils.separator2,
        monsterInfo.description,
        utils.separator2,

        -- stats
        "STATS",
    }, true)

    local statLbls, maxStatLblsLen = {}, 0
    for i, meta in ipairs(renderer.statsMeta) do
        local lbl = meta.label .. ":"
        statLbls[i] = { meta.stat, lbl }
        maxStatLblsLen = math.max(maxStatLblsLen, #lbl)
    end

    for _, data in ipairs(statLbls) do
        local stat, label = data[1], data[2]
        local attribute = monsterInfo.stats[stat]
        if not attribute then error("Stat '" .. stat .. "' missing for monster '" .. monsterName .. "'") end
        addLine(renderer.formatStatLine(maxStatLblsLen, label, attribute, maxAttribute))
    end

    -- join everything and add borders
    local lineBlock = table.concat(lines, "\n")
    return utils.addBorder(lineBlock)
end

return renderer
