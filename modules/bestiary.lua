local Utils = require("modules.utils")

local Bestiary = {}

------------------------------------------------------------
-- baseAttribute
------------------------------------------------------------

--- Base attribute scaler used to calculate stats.
--- @type number
Bestiary.baseAttribute = 100

------------------------------------------------------------
-- order
------------------------------------------------------------

--- Defines the display order of monsters for menus/UI.
--- @type string[]
Bestiary.order = {
    "Cave Slime",
    "Forest Stalker",
    "Stone Guardian",
    "Crimson Knight",
}

------------------------------------------------------------
-- monsters
------------------------------------------------------------

--- Defines all monsters in the Bestiary.
--- The key is the monster display name, and each entry includes:
--- a description, ASCII representation and stat table.
---
--- @type table<string, {
---     name: string|nil,
---     description: string,
---     representation: string,
---     stats: {
---         damage: number,
---         health: number,
---         defense: number,
---         speed: number,
---         critical: number,
---         defending: boolean,
---     }}>
Bestiary.monsters = {
    ["Cave Slime"] = {
        description = "A weak gelatinous creature that attacks by instinct.",
        representation = [[
      (o_o)
     <(___)>
        v]],
        stats = {
            damage = Bestiary.baseAttribute * 0.15,
            maxHealth = Bestiary.baseAttribute * 0.5,
            health = Bestiary.baseAttribute * 0.5,
            intelligence = Bestiary.baseAttribute * 0.05,
            defense = Bestiary.baseAttribute * 0.15,
            speed = Bestiary.baseAttribute * 0.25,
            critical = Bestiary.baseAttribute * 0.05,
            defending = false,
            hitAccumulator = 0,
            critAccumulator = 0,
            intAccumulator = 0,
        },
    },

    ["Forest Stalker"] = {
        description = "A fast creature that relies on speed and precision.",
        representation = [[
      (\_/)
      (o.o)
      / | \
        v]],
        stats = {
            damage = Bestiary.baseAttribute * 0.25,
            maxHealth = Bestiary.baseAttribute * 0.6,
            health = Bestiary.baseAttribute * 0.6,
            intelligence = Bestiary.baseAttribute * 0.25,
            defense = Bestiary.baseAttribute * 0.15,
            speed = Bestiary.baseAttribute * 0.7,
            critical = Bestiary.baseAttribute * 0.2,
            defending = false,
            hitAccumulator = 0,
            critAccumulator = 0,
            intAccumulator = 0,
        },
    },

    ["Stone Guardian"] = {
        description = "A heavily armored guardian with crushing blows.",
        representation = [[
       (>_<)
     <|#####|>
      |#####|
      V     V]],
        stats = {
            damage = Bestiary.baseAttribute * 0.35,
            maxHealth = Bestiary.baseAttribute * 1.2,
            health = Bestiary.baseAttribute * 1.2,
            intelligence = Bestiary.baseAttribute * 0.35,
            defense = Bestiary.baseAttribute * 0.6,
            speed = Bestiary.baseAttribute * 0.2,
            critical = Bestiary.baseAttribute * 0.15,
            defending = false,
            hitAccumulator = 0,
            critAccumulator = 0,
            intAccumulator = 0,
        },
    },

    ["Crimson Knight"] = {
        description = "A disciplined warrior that fights with strategy.",
        representation = [[
      [===]
      (^-^)
     <|===|>
      |^^^|
      /___\]],
        stats = {
            damage = Bestiary.baseAttribute * 0.36,
            maxHealth = Bestiary.baseAttribute * 1.3,
            health = Bestiary.baseAttribute * 1.3,
            intelligence = Bestiary.baseAttribute * 0.7,
            defense = Bestiary.baseAttribute * 0.6,
            speed = Bestiary.baseAttribute * 0.5,
            critical = Bestiary.baseAttribute * 0.3,
            defending = false,
            hitAccumulator = 0,
            critAccumulator = 0,
            intAccumulator = 0,
        },
    },
}

------------------------------------------------------------
-- Post-processing
------------------------------------------------------------

--- Injects the monster name into each entry and normalizes
--- the ASCII representation to a left-aligned layout.
for name, monster in pairs(Bestiary.monsters) do
    monster.name = name
    monster.representation = Utils.alignLeft(monster.representation)
end

return Bestiary
