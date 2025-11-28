local combat = {}

local utils = require("modules.utils")
local bestiary = require("modules.bestiary")
local monsterRenderer = require("modules.monsterRenderer")
local player = require("modules.player")

combat.start = function()
    for _, monsterName in ipairs(monsterRenderer.order) do
        local originalMonster = bestiary.monsters[monsterName]

        if not originalMonster then
            error("Monster '" .. monsterName .. "' not found in bestiary.lua. Possible fix: update renderer.order in monsterRenderer.lua.")
        end

        local monster = utils.deepCopy(originalMonster)
        local sheet = monsterRenderer.monsterSheet(monsterName, monster, bestiary.baseAttribute)
        local monsterStats = monster.stats
        local playerStats = utils.deepCopy(player.stats)
        local initialLines, initialAddLine = utils.newBuffer()

        print(sheet)

        initialAddLine({
            utils.separator2,
            "A wild creature appears!",
            "You've entered into combat with a creature."
        }, true)

        local initialLineBlock = table.concat(initialLines, "\n")
        print(utils.addBorder(initialLineBlock))

        while true do
            local combatLines, combatAddLine = utils.newBuffer()

            combatAddLine({
                utils.separator2,
                "What is your action?",
            }, true)

            local combatLineBlock = table.concat(combatLines, "\n")
            print(utils.addBorder(combatLineBlock))

            local function validCombatInput()
                local playerActions = utils.formatActions(player.actions)
                print(utils.addBorder(playerActions))

                local combatInput = tonumber(utils.customIoRead())

                if player.actions[combatInput] then
                    player.actions[combatInput].action(monsterStats, playerStats)
                else
                    local lines, addLine = utils.newBuffer()

                    addLine({
                        utils.separator2,
                        "Invalid number option. Please try again.",
                    }, true)

                    local lineBlock = table.concat(lines, "\n")
                    print(utils.addBorder(lineBlock))
                    validCombatInput()
                end
            end

            validCombatInput()

            if monsterStats.health <= 0 then
                local lines, addLine = utils.newBuffer()

                addLine({
                    utils.separator1,
                    "You have defeated the creature!",
                    "Enter any key to continue.",
                }, true)

                local lineBlock = table.concat(lines, "\n")
                print(utils.addBorder(lineBlock))
                local input = utils.customIoRead()
                break
            end
        end
        ::continue::
    end
end

return combat
