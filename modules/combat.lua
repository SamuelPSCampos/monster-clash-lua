local Utils = require("modules.utils")
local Bestiary = require("modules.bestiary")
local Renderer = require("modules.renderer")
local Player = require("modules.player")
local CombatActions = require("modules.combat_actions")
local CombatLogic = require("modules.combat_logic")
local AsciiArts = require("modules.ascii_arts")

local Combat = {}

Combat.start = function()
    local function validCombatInput(monster, player)
        while true do
            Utils.showScreen({
                Utils.formatActions(
                    CombatActions.actions,
                    CombatActions.actionsOrder
                )
            })

            local input = tonumber(Utils.customIoRead())

            if input then
                local actionId = CombatActions.actionsOrder[input]
                local action = actionId and CombatActions.actions[actionId]

                if action then
                    action.action(player, monster)
                    return
                end
            end

            Utils.showScreen({
                Utils.separators[2],
                "Invalid number option. Please try again.",
            })
        end
    end

    local player = Utils.deepCopy(Player)
    local playerStats = player.stats

    for _, monsterName in ipairs(Bestiary.order) do
        local originalMonster = Bestiary.monsters[monsterName]

        if not originalMonster then
            error("Monster '" ..
                monsterName .. "' not found in Bestiary.monsters. Possible fix: update Bestiary.order.")
        end

        local monster = Utils.deepCopy(originalMonster)
        local monstherSheet = Renderer.entitySheet({ info = monster })
        local monsterStats = monster.stats
        local playerSheet = Renderer.entitySheet({ info = player })

        print(playerSheet)
        print(monstherSheet)

        Utils.showScreen({
            Utils.separators[2],
            "A wild creature appears!",
            "You've entered into combat with a creature."
        })

        while true do
            local monsterActionId = CombatLogic.chooseMonsterAction(monsterStats)
            local monsterAction = CombatActions.actions[monsterActionId]

            Utils.showScreen({
                Utils.separators[2],
                string.format(
                    "'%s' will: '%s'",
                    monsterName, monsterAction.label
                ),
                "What is your action?",
            })

            playerStats.defending = false
            validCombatInput(monster, player)

            if monsterStats.health <= 0 then
                Utils.showScreen({
                    Utils.separators[1],
                    "You have defeated the creature!",
                    "Press 'Enter' to continue.",
                })

                Utils.customIoRead()
                break
            end

            Utils.showScreen({
                Utils.separators[2],
            })

            monsterStats.defending = false
            monsterAction.action(monster, player)

            if playerStats.health <= 0 then
                Utils.showScreen({
                    Utils.separators[1],
                    AsciiArts.defeat,
                    "Press 'Enter' to return to the menu.",
                })

                Utils.customIoRead()
                return
            end
        end
    end

    Utils.showScreen({
        Utils.separators[1],
        AsciiArts.congratulations,
        "Press 'Enter' to return to the menu.",
    })

    Utils.customIoRead()
end

return Combat
