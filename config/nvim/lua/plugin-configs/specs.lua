require('specs').setup{
  show_jumps = true,
  min_jump = 2,
  popup = {
    delay_ms = 0, -- delay before animation displays
    inc_ms  = 5, -- time increments use for fade/resize effects
    blend = 0, -- starting blend, between 1-100 (fully transparent)
    width = 50,
    winhl = "DiffAdd", -- default was "PMenu",
    fader = require('specs').linear_fader, -- linear_fader, exp_fader, pulse_fader, empty_fader
    resizer = require('specs').shrink_resizer -- shrink_resizer, slide_resizer, empty_resizer
  },
  ignore_filetyes = {},
  ignore_buftypes = {
    nofile = true,
  },
}
