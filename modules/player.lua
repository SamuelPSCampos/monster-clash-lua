local utils = require("modules.utils")
local renderer = require("modules.renderer")
local bestiary = require("modules.bestiary")

local player = {}

------------------------------------------------------------
-- Base Player Stats
------------------------------------------------------------

player.stats = {
    damage = bestiary.baseAttribute * 0.1,
    health = bestiary.baseAttribute * 1.0,
    defense = bestiary.baseAttribute * 0.2,
    speed = bestiary.baseAttribute * 0.9,
}

------------------------------------------------------------
-- Player Actions
------------------------------------------------------------

---@class PlayerAction
---@field label string
---@field action fun(monsterStats: table, playerStats: table)

---@type PlayerAction[]
player.actions = {

    --------------------------------------------------------
    -- Attack
    --------------------------------------------------------
    {
        label = "Attack",
        action = function(monsterStats, playerStats)
            local statLabel = "Health:"
            local chance = math.random(1, bestiary.baseAttribute)

            if chance <= playerStats.speed then
                monsterStats.health = monsterStats.health - playerStats.damage

                utils.showScreen({
                    "You attack the creature for " .. playerStats.damage .. " damage!",
                    renderer.formatStatLine({ label = statLabel, attribute = monsterStats.health, }),
                })
            else
                print(utils.addBorder("Your attack missed!"))
            end
        end,
    },

    --------------------------------------------------------
    -- Defend
    --------------------------------------------------------
    {
        label = "Defend",
        action = function(monsterStats, playerStats)
            -- TODO: defense logic
        end,
    },
}

return player
