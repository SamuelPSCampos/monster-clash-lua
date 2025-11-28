local menu = {}

local utils = require("modules.utils")
local game = require("modules.combat")

local title = utils.alignLeft([[
                        _                ___ _           _
  /\/\   ___  _ __  ___| |_ ___ _ __    / __\ | __ _ ___| |__
 /    \ / _ \| '_ \/ __| __/ _ \ '__|  / /  | |/ _` / __| '_ \
/ /\/\ \ (_) | | | \__ \ ||  __/ |    / /___| | (_| \__ \ | | |
\/    \/\___/|_| |_|___/\__\___|_|    \____/|_|\__,_|___/_| |_|]])
local titleIdentation = "         "
function menu.start()
    local lines, addLine = utils.newBuffer()

    addLine({
        utils.separator1,
        utils.indentLines(title, titleIdentation),
        utils.separator1,
        "Welcome to Monster Clash!",
        utils.separator2,
        "In this game, you will face various monsters.",
        "Choose your actions wisely to defeat them all!",
        utils.separator2,
        "Enter the option number.",
    }, true)

    local lineBlock = table.concat(lines, "\n")
    print(utils.addBorder(lineBlock))

    menu.options()
end

menu.actions = {
    {
        label = "Play",
        action = function()
            game.start()
        end,
    },

    {
        label = "Credits",
        action = function()
            local lines, addLine = utils.newBuffer()
            local heart = utils.alignLeft([[
                ** **
               *******
                *****
                 ***
                  *]])

            addLine({
                utils.separator1,
                "Monster Clash",
                "Developed by Samuel Campos",
                "MIT License",
                "Thank you for playing!",
                utils.indentLines(heart, "       "),
                utils.separator2,
                "Enter any key to return to the menu.",
            }, true)

            local lineBlock = table.concat(lines, "\n")
            print(utils.addBorder(lineBlock))

            local input = utils.customIoRead()
            print(utils.addBorder(utils.separator1))
            menu.options()
        end,
    },

    {
        label = "Quit",
        action = function()
            local lines, addLine = utils.newBuffer()

            addLine({
                utils.separator1,
                "Are you sure you want to quit? All data will be lost.",
                "Enter 'y' to quit, or any other key to cancel.",
            }, true)

            local lineBlock = table.concat(lines, "\n")
            print(utils.addBorder(lineBlock))

            local input = utils.customIoRead()
            local isY = input and input:lower() == "y"

            if isY then
                os.exit()
            else
                print(utils.addBorder(utils.separator1))
                menu.options()
            end
        end,
    },
}

function menu.options()
    local menuActions = utils.formatActions(menu.actions)
    print(utils.addBorder(menuActions))

    local input = tonumber(utils.customIoRead())

    if input and menu.actions[input] then
        menu.actions[input].action()
    else
        local lines, addLine = utils.newBuffer()
        addLine({
            utils.separator1,
            "Invalid option number. Please try again.",
        }, true)

        local lineBlock = table.concat(lines, "\n")
        print(utils.addBorder(lineBlock))
        menu.options()
    end
end

return menu
