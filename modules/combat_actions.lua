local Utils = require("modules.utils")
local Renderer = require("modules.renderer")
local CombatLogic = require("modules.combat_logic")

local CombatActions = {}

------------------------------------------------------------
-- CombatActions.actionsOrder
------------------------------------------------------------

--- Defines the explicit display and selection order for combat actions.
--- Each entry must match a valid key in CombatActions.actions.
--- The numeric index is used for user input during combat.
CombatActions.actionsOrder = {
    "attack",
    "defend",
    "heal",
}

------------------------------------------------------------
-- Combat Actions
------------------------------------------------------------

--- Fraction of maxHealth restored (e.g., 10% of maxHealth)
local HEAL_RATE <const> = 0.1

---@class CombatAction
---@field label string
---@field action fun(attacker: table, defender: table)

---@type CombatAction[]
CombatActions.actions = {

    --------------------------------------------------------
    -- Attack
    --------------------------------------------------------
    ["attack"] = {
        label = "Attack",
        action = function(attacker, defender)
            local attackerName = attacker.name
            local attackResult = CombatLogic.resolveAttack(attacker, defender)

            local defenderStats = defender.stats
            local defenderName = defender.name

            if attackResult.hit then
                defenderStats.health = defenderStats.health - attackResult.damage

                Utils.showScreen({
                    string.format(
                        "'%s' attacks '%s' for %d damage!",
                        attackerName, defenderName, attackResult.damage
                    ),
                    Renderer.formatStatLine({
                        label = defenderName .. " - HP:",
                        attribute = defenderStats.health,
                    }),
                })
            else
                Utils.showScreen({
                    string.format(
                        "%s - attack missed!",
                        attackerName
                    ),
                })
            end
        end,
    },

    --------------------------------------------------------
    -- Defend
    --------------------------------------------------------
    ["defend"] = {
        label = "Defend",
        action = function(attacker, defender)
            local attackerName = attacker.name

            attacker.defending = true
            Utils.showScreen({
                attackerName .. " - is defending!",
            })
        end,
    },

    --------------------------------------------------------
    -- Heal
    --------------------------------------------------------
    ["heal"] = {
        label = "Heal",
        action = function(attacker, defender)
            local attackerStats = attacker.stats
            local attackerName = attacker.name

            if attackerStats.health >= attackerStats.maxHealth then
                Utils.showScreen({
                    attackerName .. " - already at full health. Turn skipped!",
                })
                return
            end

            local healAmount = math.floor(attackerStats.maxHealth * HEAL_RATE)
            local missing = attackerStats.maxHealth - attackerStats.health

            if healAmount > missing then healAmount = missing end

            attackerStats.health = attackerStats.health + healAmount

            Utils.showScreen({
                string.format(
                    "'%s' restored %d health!",
                    attackerName, healAmount),
                Renderer.formatStatLine({
                    label = attackerName .. " - HP:",
                    attribute = attackerStats.health
                }),
            })
        end,
    },
}

return CombatActions
