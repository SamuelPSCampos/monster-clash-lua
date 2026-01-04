local Bestiary = require("modules.bestiary")
local Utils = require("modules.utils")

local Player = {}

------------------------------------------------------------
-- Player
------------------------------------------------------------

Player.name = "You"

Player.description = "You..."

Player.representation = Utils.alignLeft([[
  ___
 |___|
 | | |
 |_|_|
  | |]])

Player.stats = {
    damage = Bestiary.baseAttribute * 0.35,
    maxHealth = Bestiary.baseAttribute * 1.2,
    health = Bestiary.baseAttribute * 1.2,
    defense = Bestiary.baseAttribute * 0.3,
    speed = Bestiary.baseAttribute * 0.8,
    critical = Bestiary.baseAttribute * 0.25,
    defending = false,
    hitAccumulator = 0,
    critAccumulator = 0,
}

return Player
