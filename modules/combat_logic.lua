local CombatLogic = {}

local Utils = require("modules.utils")
local Bestiary = require("modules.bestiary")

------------------------------------------------------------
-- rollHit
------------------------------------------------------------

--- Minimum allowed hit chance after clamping
local HIT_CHANCE_MIN <const> = 0.05

--- Maximum allowed hit chance after clamping
local HIT_CHANCE_MAX <const> = 0.95

--- Computes the probability that an attack hits the defender,
--- based on speed comparison between attacker and defender.
--- Returns both the boolean hit result and the calculated hitChance.
---
--- @param attackerStats table Table with numeric fields: speed
--- @param defenderStats table Table with numeric fields: speed
--- @return boolean didHit Whether the attack hit
--- @return number hitChance The computed chance to hit
function CombatLogic.rollHit(attackerStats, defenderStats)
    local rawChance = attackerStats.speed / (attackerStats.speed + defenderStats.speed)
    local clampedChance = Utils.clamp(rawChance, HIT_CHANCE_MIN, HIT_CHANCE_MAX)
    local hitChance = Utils.smoothChance(clampedChance)

    attackerStats.hitAccumulator = attackerStats.hitAccumulator + hitChance

    if math.random() < attackerStats.hitAccumulator then
        attackerStats.hitAccumulator = attackerStats.hitAccumulator - 1
        return true, hitChance
    end

    return false, hitChance
end

------------------------------------------------------------
-- rollCritical
------------------------------------------------------------

--- Minimum allowed critical chance after clamping
local CRIT_CHANCE_MIN <const> = 0.01

--- Maximum allowed critical chance after clamping
local CRIT_CHANCE_MAX <const> = 0.35

--- Determines whether an attack is a critical hit using a smoothed
--- and clamped critical chance with anti-streak accumulation.
---
--- @param attackerStats table Table with numeric field: critical
--- @return boolean isCritical, number critChance
function CombatLogic.rollCritical(attackerStats)
    local rawCrit = Utils.clamp(attackerStats.critical, CRIT_CHANCE_MIN, CRIT_CHANCE_MAX)
    local critChance = Utils.smoothChance(rawCrit)

    attackerStats.critAccumulator = attackerStats.critAccumulator + critChance

    if math.random() < attackerStats.critAccumulator then
        attackerStats.critAccumulator = attackerStats.critAccumulator - 1
        return true, critChance
    end

    return false, critChance
end

------------------------------------------------------------
-- rollIntelligence
------------------------------------------------------------

--- Minimum normalized chance for an intelligent decision.
--- Prevents monsters from acting intelligently too rarely.
local INTE_MIN <const> = 0.1

--- Maximum normalized chance for an intelligent decision.
--- Prevents monsters from acting with perfect decision-making.
local INTE_MAX <const> = 0.9

function CombatLogic.rollIntelligence(monsterStats)
    monsterStats.intAccumulator = monsterStats.intAccumulator

    local rawChance = monsterStats.intelligence / Bestiary.baseAttribute
    local clamped = Utils.clamp(rawChance, INTE_MIN, INTE_MAX)
    local smartChance = Utils.smoothChance(clamped)

    monsterStats.intAccumulator = monsterStats.intAccumulator + smartChance

    local actedSmart = false
    if math.random() < math.min(monsterStats.intAccumulator, 1) then
        monsterStats.intAccumulator = monsterStats.intAccumulator - 1
        actedSmart = true
    end

    return actedSmart, smartChance
end

function CombatLogic.getBestAction(stats)
    local hpRatio = stats.health / stats.maxHealth

    if hpRatio <= 0.3 then
        return "heal"
    elseif hpRatio <= 0.5 then
        return "defend"
    else
        return "attack"
    end
end

function CombatLogic.chooseMonsterAction(monsterStats)
    local actedSmart = CombatLogic.rollIntelligence(monsterStats)

    if actedSmart then
        return CombatLogic.getBestAction(monsterStats)
    end

    local roll = math.random()

    if roll < 0.8 then
        return "attack"
    elseif roll < 0.9 then
        return "defend"
    else
        return "heal"
    end
end

------------------------------------------------------------
-- calculateBaseDamage
------------------------------------------------------------

--- Multiplier applied when not defending (e.g., 50% of defense)
local DEF_REDUCTION_RATE <const> = 0.5

--- Computes base damage after applying a non-linear defense reduction.
--- Passive defense is reduced when the defender is not actively defending.
--- Result is floored and clamped to a minimum of 1.
---
--- @param attackerStats table { damage: number }
--- @param defenderStats table { defense: number, defending: boolean }
--- @return number baseDamage
function CombatLogic.calculateBaseDamage(attackerStats, defenderStats)
    local defense = defenderStats.defense
    local attack = attackerStats.damage

    if not defenderStats.defending then
        defense = defense * DEF_REDUCTION_RATE
    end

    local multiplier = attack / (attack + defense)
    local damage = math.floor(attack * multiplier)

    return math.max(1, damage)
end

------------------------------------------------------------
-- resolveAttack
------------------------------------------------------------

--- Multiplier applied when an attack is critical (e.g., +50% damage)
local CRIT_RATE <const> = 1.5

---@class AttackResult
---@field hit boolean       -- attack connected
---@field hitChance number  -- computed chance to hit
---@field critical boolean  -- critical hit occurred
---@field critChance number -- computed chance to crit
---@field damage number     -- final applied damage
---@field rawDamage number  -- damage before critical

--- Resolves a full attack sequence between attacker and defender.
--- Process includes hit chance, base damage, critical check,
--- and application of the critical multiplier.
---
--- @param attacker table { damage: number, health: number, defense: number, speed: number, critical: number, defending: boolean, }
--- @param defender table { damage: number, health: number, defense: number, speed: number, critical: number, defending: boolean, }
--- @return AttackResult attackResult { hit: boolean, hitChance: number, critical: boolean, critChance: number, damage: number, rawDamage: number, }
function CombatLogic.resolveAttack(attacker, defender)
    local attackerStats = attacker.stats
    local defenderStats = defender.stats
    local attackResult = {
        hit = false,
        hitChance = 0,
        critical = false,
        critChance = 0,
        damage = 0,
        rawDamage = 0,
    }

    -- Hit calculation
    local didHit, hitChance = CombatLogic.rollHit(attackerStats, defenderStats)
    attackResult.hit = didHit
    attackResult.hitChance = hitChance

    if not didHit then
        return attackResult
    end

    -- Base damage
    local baseDamage = CombatLogic.calculateBaseDamage(attackerStats, defenderStats)
    attackResult.rawDamage = baseDamage

    -- Critical calculation
    local isCrit, critChance = CombatLogic.rollCritical(attackerStats)
    attackResult.critical = isCrit
    attackResult.critChance = critChance

    if isCrit then
        baseDamage = math.floor(baseDamage * CRIT_RATE)
    end

    attackResult.damage = baseDamage

    return attackResult
end

return CombatLogic
