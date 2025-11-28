local bestiary = require("modules.bestiary")
local renderer = require("modules.monsterRenderer")
local utils = require("modules.utils")

local player = {}

player.stats = {
    damage = bestiary.baseAttribute * 0.1,
    health = bestiary.baseAttribute * 1.0,
    defense = bestiary.baseAttribute * 0.2,
    speed = bestiary.baseAttribute * 0.9,
}

player.actions = {
    {
        label = "Attack",
        action = function(monsterStats, playerStats)
            local label = "Health:"
            local chance = math.random(1, bestiary.baseAttribute)

            if chance <= playerStats.speed then
                monsterStats.health = monsterStats.health - playerStats.damage

                local lines, addLine = utils.newBuffer()

                addLine({
                    "You attack the creature for " .. playerStats.damage .. " damage!",
                    renderer.formatStatLine(#label, label, monsterStats.health, bestiary.baseAttribute),
                }, true)

                local lineBlock = table.concat(lines, "\n")
                print(utils.addBorder(lineBlock))
            else
                print(utils.addBorder("Your attack missed!"))
            end
        end,
    },

    {
        label = "Defend",
        action = function(monsterStats, playerStats)

        end,
    },
}

return player
