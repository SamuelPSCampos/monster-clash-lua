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

    Menu.options()
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
            Menu.start() -- when the combat ends, the game returns to the menu
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
            print(Utils.addBorder(Utils.separators[1]))

            Menu.options()
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
            local isY = input and input:lower() == "y"

            if isY then
                os.exit()
            else
                print(Utils.addBorder(Utils.separators[1]))
                Menu.options()
            end
        end,
    },
}

------------------------------------------------------------
-- Menu.options
------------------------------------------------------------

--- Displays the list of actions and waits for user input.
--- If the user selects a valid option, that action is executed.
--- Otherwise an error screen is shown and the menu repeats.
--- @return nil
function Menu.options()
    local menuText = Utils.formatActions(Menu.actions, Menu.actionsOrder)
    print(Utils.addBorder(menuText))

    local input = tonumber(Utils.customIoRead())

    if input then
        local actionId = Menu.actionsOrder[input]
        local action = actionId and Menu.actions[actionId]

        if action then
            action.action()
            return
        end
    end

    Utils.showScreen({
        Utils.separators[1],
        "Invalid option number. Please try again.",
    })

    Menu.options()
end

return Menu
