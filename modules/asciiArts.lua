local asciiArts = {}

local utils = require("modules.utils")

asciiArts.heartCredits = [[
 ** **
*******
 *****
  ***
   *]]

asciiArts.gameTitle = [[
                        _                ___ _           _
  /\/\   ___  _ __  ___| |_ ___ _ __    / __\ | __ _ ___| |__
 /    \ / _ \| '_ \/ __| __/ _ \ '__|  / /  | |/ _` / __| '_ \
/ /\/\ \ (_) | | | \__ \ ||  __/ |    / /___| | (_| \__ \ | | |
\/    \/\___/|_| |_|___/\__\___|_|    \____/|_|\__,_|___/_| |_|]]

for key, art in pairs(asciiArts) do
    asciiArts[key] = utils.alignLeft(art)
end

return asciiArts