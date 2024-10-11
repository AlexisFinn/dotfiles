local lush = require("lush")
local hsl = lush.hsl

local sea_foam = hsl(200, 30, 40)
local light_teal = hsl(189, 40, 60)
local dark_yellow = hsl(50, 80, 65)
local pastel_green = hsl(110, 40, 70)
local light_pink = hsl(320, 50, 80)

---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
  local sym = injected_functions.sym
  return {
    -- Normal({ fg = sea_foam, bg = "black" }),
    Keyword({ fg = light_teal }),
    Comment({ fg = sea_foam }),
    String({ fg = pastel_green }),
    sym("@lsp.type.variable.javascript")({ fg = dark_yellow }),
    sym("@lsp.type.member.javascript")({ fg = light_pink }),
  }
end)

return theme
