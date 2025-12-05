local bestiary = {}

local utils = require("modules.utils")

bestiary.baseAttribute = 100

bestiary.statsMeta = {
    { stat = "damage",  label = "Damage" },
    { stat = "health",  label = "Health" },
    { stat = "defense", label = "Defense" },
    { stat = "speed",   label = "Speed" },
}

bestiary.order = {
    "Monster 1",
    "Monster 2",
    "Monster 3",
    "Monster 4",
}

bestiary.monsters = {
    ["Monster 1"] = {
        description = "Monster 1 description",
        representation = [[
         (0_0)
        /|^^^|\
         |^^^|
         v   v]],
        stats = {
            damage = bestiary.baseAttribute * 0.2,
            health = bestiary.baseAttribute * 0.4,
            defense = bestiary.baseAttribute * 0.2,
            speed = bestiary.baseAttribute * 0.3,
        },
    },

    ["Monster 2"] = {
        description = "Monster 2 description",
        representation = [[
        (\_/)
        (o.o)
        /   \
         v]],
        stats = {
            damage = bestiary.baseAttribute * 0.3,
            health = bestiary.baseAttribute * 0.3,
            defense = bestiary.baseAttribute * 0.15,
            speed = bestiary.baseAttribute * 0.7,
        },
    },

    ["Monster 3"] = {
        description = "Monster 3 description",
        representation = [[
         (>_<)========
        /|#####|\
         |#####|
         V     V]],
        stats = {
            damage = bestiary.baseAttribute * 0.6,
            health = bestiary.baseAttribute * 0.9,
            defense = bestiary.baseAttribute * 0.5,
            speed = bestiary.baseAttribute * 0.2,
        },
    },

    ["Monster 4"] = {
        description = "Monster 4 description",
        representation = [[
         (^-^)
        <|===|>
         |^^^|
         / v \
         \___/]],
        stats = {
            damage = bestiary.baseAttribute * 0.8,
            health = bestiary.baseAttribute * 1.0,
            defense = bestiary.baseAttribute * 0.7,
            speed = bestiary.baseAttribute * 0.6,
        },
    }
}

for _, monster in pairs(bestiary.monsters) do
    monster.representation = utils.alignLeft(monster.representation)
end

return bestiary
