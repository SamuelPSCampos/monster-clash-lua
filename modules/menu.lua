local utils = require("modules.utils")
local combat = require("modules.combat")
local asciiArts = require("modules.asciiArts")

local menu = {}

------------------------------------------------------------
-- menu.start
------------------------------------------------------------

--- Starts the game menu.
--- Displays the title screen and then the list of options.
--- @return nil
function menu.start()
    utils.showScreen({
        utils.separators[1],
        utils.indentLines(asciiArts.gameTitle, 9),
        utils.separators[1],
        "Welcome to Monster Clash!",
        utils.separators[2],
        "In this game, you will face various monsters.",
        "Choose your actions wisely to defeat them all!",
        utils.separators[2],
        "Enter the option number.",
    })

    menu.options()
end

------------------------------------------------------------
-- menu.actions
------------------------------------------------------------

--- @class MenuAction
--- @field label string Display name for the option.
--- @field action fun() Function called when the option is selected.

--- List of menu actions available to the player.
--- @type MenuAction[]
menu.actions = {

    --------------------------------------------------------
    -- Play
    --------------------------------------------------------
    {
        label = "Play",
        action = function()
            combat.start()
        end,
    },

    --------------------------------------------------------
    -- Credits
    --------------------------------------------------------
    {
        label = "Credits",
        action = function()
            utils.showScreen({
                utils.separators[1],
                "Monster Clash",
                "Developed by Samuel Campos",
                "MIT License",
                "Thank you for playing!",
                utils.indentLines(asciiArts.heartCredits, 7),
                utils.separators[2],
                "Press 'Enter' to return to the menu.",
            })

            utils.customIoRead()
            print(utils.addBorder(utils.separators[1]))

            menu.options()
        end,
    },

    --------------------------------------------------------
    -- Quit
    --------------------------------------------------------
    {
        label = "Quit",
        action = function()
            utils.showScreen({
                utils.separators[1],
                "Are you sure you want to quit? All data will be lost.",
                "Enter 'y' to quit, or any other key to cancel.",
            })

            local input = utils.customIoRead()
            local isY = input and input:lower() == "y"

            if isY then
                os.exit()
            else
                print(utils.addBorder(utils.separators[1]))
                menu.options()
            end
        end,
    },
}

------------------------------------------------------------
-- menu.options
------------------------------------------------------------

--- Displays the list of actions and waits for user input.
--- If the user selects a valid option, that action is executed.
--- Otherwise an error screen is shown and the menu repeats.
--- @return nil
function menu.options()
    local menuActions = utils.formatActions(menu.actions)
    print(utils.addBorder(menuActions))

    local input = tonumber(utils.customIoRead())

    if input and menu.actions[input] then
        menu.actions[input].action()
        return
    end

    utils.showScreen({
        utils.separators[1],
        "Invalid option number. Please try again.",
    })

    menu.options()
end

return menu
