local utils = require("modules.utils")
local bestiary = require("modules.bestiary")
local renderer = require("modules.renderer")
local player = require("modules.player")

local combat = {}

combat.start = function()
    for _, monsterName in ipairs(bestiary.order) do
        local originalMonster = bestiary.monsters[monsterName]

        if not originalMonster then
            error("Monster '" ..
            monsterName .. "' not found in bestiary.lua. Possible fix: update bestiary.order.")
        end

        local monster = utils.deepCopy(originalMonster)
        local sheet = renderer.monsterSheet({
            name = monsterName,
            info = monster,
        })
        local monsterStats = monster.stats
        local playerStats = utils.deepCopy(player.stats)
        local initialLines = utils.newBuffer()

        print(sheet)

        initialLines:extend({
            utils.separators[2],
            "A wild creature appears!",
            "You've entered into combat with a creature."
        })

        local initialLineBlock = table.concat(initialLines, "\n")
        print(utils.addBorder(initialLineBlock))

        while true do
            local combatLines = utils.newBuffer()

            combatLines:extend({
                utils.separators[2],
                "What is your action?",
            })

            local combatLineBlock = table.concat(combatLines, "\n")
            print(utils.addBorder(combatLineBlock))

            local function validCombatInput()
                local playerActions = utils.formatActions(player.actions)
                print(utils.addBorder(playerActions))

                local combatInput = tonumber(utils.customIoRead())

                if player.actions[combatInput] then
                    player.actions[combatInput].action(monsterStats, playerStats)
                else
                    local lines = utils.newBuffer()

                    lines:extend({
                        utils.separators[2],
                        "Invalid number option. Please try again.",
                    })

                    local lineBlock = table.concat(lines, "\n")
                    print(utils.addBorder(lineBlock))
                    validCombatInput()
                end
            end

            validCombatInput()

            if monsterStats.health <= 0 then
                local lines = utils.newBuffer()

                lines:extend({
                    utils.separators[1],
                    "You have defeated the creature!",
                    "Enter any key to continue.",
                })

                local lineBlock = table.concat(lines, "\n")
                print(utils.addBorder(lineBlock))
                local input = utils.customIoRead()
                break
            end
        end
    end
end

return combat
