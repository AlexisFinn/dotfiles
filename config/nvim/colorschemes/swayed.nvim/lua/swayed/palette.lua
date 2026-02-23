local colorsLib = require("lib.colors")

-- Base chalk palette
local chalk_base = colorsLib.new(200, .2, .85)
local chalk_foam = colorsLib.new(200, .2, .40)
local chalk_teal = colorsLib.new(189, .30, .60)
local chalk_purple = colorsLib.new(240, .40, .75)
local chalk_yellow = colorsLib.new(50, .60, .80)
local chalk_green = colorsLib.new(110, .30, .70)
local chalk_pink = colorsLib.new(320, .50, .80)
local chalk_board = colorsLib.new(120, .10, .07)
local chalk_blue = colorsLib.new(209, .60, .60)
local diag_error = colorsLib.new(321, .35, .28)

local NvimDarkBlue = colorsLib.new(199, .31, .23)
local NvimDarkCyan = colorsLib.new(180, .33, .23)
local NvimDarkGreen = colorsLib.new(142, .43, .17)
local NvimDarkMagenta = colorsLib.new(302, 1.0, .14)
local NvimDarkRed = colorsLib.new(352, 1.0, .17)
local NvimDarkYellow = colorsLib.new(45, 1.0, .21)
local NvimLightBlue = colorsLib.new(205, 1.0, .83)
local NvimLightCyan = colorsLib.new(179, .86, .76)
local NvimLightGreen = colorsLib.new(142, .74, .83)
local NvimLightMagenta = colorsLib.new(300, 1.0, .89)
local NvimLightRed = colorsLib.new(6, 1.0, .86)
local NvimLightYellow = colorsLib.new(42, .96, .78)
local NvimLightGrey1 = colorsLib.new(222, .34, .95)
local NvimLightGrey2 = colorsLib.new(225, .22, .90)
local NvimLightGrey3 = colorsLib.new(226, .10, .78)
local NvimLightGrey4 = colorsLib.new(222, .06, .63)
local NvimDarkGrey4 = colorsLib.new(220, .06, .33)
local NvimDarkGrey3 = colorsLib.new(220, .08, .19)
local NvimDarkGrey2 = colorsLib.new(220, .14, .09)
local NvimDarkGrey1 = colorsLib.new(225, .30, .04)
-- Derived semantic tokens built from the base chalk colors
return {
    -- raw chalk colors (exposed for direct use)
    chalk_base = tostring(chalk_base),
    chalk_foam = tostring(chalk_foam),
    chalk_teal = tostring(chalk_teal),
    chalk_purple = tostring(chalk_purple),
    chalk_yellow = tostring(chalk_yellow),
    chalk_green = tostring(chalk_green),
    chalk_pink = tostring(chalk_pink),
    chalk_board = tostring(chalk_board),
    chalk_blue = tostring(chalk_blue),

    -- UI / general
    fg = tostring(chalk_base),
    bg = tostring(chalk_board),
    white = tostring(chalk_base:lighten_by(1.1)),
    black = tostring(chalk_board),
    nontext = tostring(chalk_board:lighten_by(1.25)),
    statusline = tostring(chalk_foam:lighten_by(1.07)),
    menu = tostring(chalk_foam),
    menubg = tostring(chalk_board:lighten_by(1.03)),
    visual = tostring(chalk_foam:lighten_by(.85)),
    selection = tostring(chalk_foam:lighten_by(.78)),
    cursor = tostring(chalk_yellow),

    -- syntax groups
    comment = tostring(chalk_foam:lighten_by(.82)),
    number = tostring(chalk_blue),
    string = tostring(chalk_green),
    constant = tostring(chalk_pink),
    cyan = tostring(chalk_teal),
    blue = tostring(chalk_blue),
    magenta = tostring(chalk_purple),
    yellow = tostring(chalk_yellow),
    red = tostring(diag_error),

    -- brighter variants
    bright_red = tostring(diag_error:lighten_by(1.08)),
    bright_cyan = tostring(chalk_teal:lighten_by(1.12)),
    bright_magenta = tostring(chalk_purple:lighten_by(1.12)),
    bright_yellow = tostring(chalk_yellow:lighten_by(1.15)),
    bright_cyan_alt = tostring(chalk_teal:lighten_by(1.20)),

    -- language/semantic tokens
    operator = tostring(chalk_blue),
    keyword = tostring(chalk_purple),
    Function = tostring(chalk_blue),
    type = tostring(chalk_teal),
    variable = tostring(chalk_base),

    -- diagnostic
    diag_error = tostring(diag_error),

    -- helpers
    menu_item = tostring(chalk_foam)
}
