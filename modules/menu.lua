local Utils = require("modules.utils")
local Combat = require("modules.combat")
local AsciiArts = require("modules.ascii_arts")

local Menu = {}

Utils.initRandom() -- Initialize RNG when menu module loads

------------------------------------------------------------
-- Menu.start
------------------------------------------------------------

--- Starts the game menu.
--- Displays the title screen and then the list of options.
--- @return nil
function Menu.start()
    Utils.showScreen({
        Utils.separators[1],
        Utils.indentLines(AsciiArts.gameTitle, 9),
        Utils.separators[1],
        "Welcome to Monster Clash!",
        Utils.separators[2],
        "In this game, you will face various monsters.",
        "Choose your actions wisely to defeat them all!",
        Utils.separators[2],
        "Enter the option number.",
    })

    Menu.loop()
end

------------------------------------------------------------
-- Menu.actionsOrder
------------------------------------------------------------

--- Defines the explicit display and selection order for menu actions.
--- Each entry must match a valid key in Menu.actions.
--- The numeric position determines the option number shown to the user.
Menu.actionsOrder = {
    "play",
    "credits",
    "quit",
}

------------------------------------------------------------
-- Menu.actions
------------------------------------------------------------

--- @class MenuAction
--- @field label string Display name for the option.
--- @field action fun() Function called when the option is selected.

--- List of menu actions available to the player.
--- @type MenuAction[]
Menu.actions = {

    --------------------------------------------------------
    -- Play
    --------------------------------------------------------
    ["play"] = {
        label = "Play",
        action = function()
            Combat.start()
        end,
    },

    --------------------------------------------------------
    -- Credits
    --------------------------------------------------------
    ["credits"] = {
        label = "Credits",
        action = function()
            Utils.showScreen({
                Utils.separators[1],
                "Monster Clash",
                "Developed by Samuel Campos",
                "MIT License",
                "Thank you for playing!",
                Utils.indentLines(AsciiArts.heartCredits, 7),
                Utils.separators[2],
                "Press 'Enter' to return to the menu.",
            })

            Utils.customIoRead()
        end,
    },

    --------------------------------------------------------
    -- Quit
    --------------------------------------------------------
    ["quit"] = {
        label = "Quit",
        action = function()
            Utils.showScreen({
                Utils.separators[1],
                "Are you sure you want to quit? All data will be lost.",
                "Enter 'y' to quit, or any other key to cancel.",
            })

            local input = Utils.customIoRead()
            if input and input:lower() == "y" then
                os.exit()
            end
        end,
    },
}

------------------------------------------------------------
-- Menu.loop
------------------------------------------------------------

--- Runs the main menu loop.
--- Continuously displays the menu options, waits for user input,
--- and executes the selected action.
--- This loop is intentionally infinite and only ends when the
--- application exits (e.g. via the "Quit" action).
--- Invalid inputs are handled gracefully without using recursion,
--- preventing stack overflow.
--- @return nil
function Menu.loop()
    while true do
        local menuText = Utils.formatActions(Menu.actions, Menu.actionsOrder)
        print(Utils.addBorder(menuText))

        local input = tonumber(Utils.customIoRead())
        local actionId = input and Menu.actionsOrder[input]
        local action = actionId and Menu.actions[actionId]

        if action then
            action.action()
        else
            Utils.showScreen({
                Utils.separators[1],
                "Invalid option number. Please try again.",
            })
        end
    end
end

return Menu
