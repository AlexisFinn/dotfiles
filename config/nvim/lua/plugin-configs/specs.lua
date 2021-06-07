require('specs').setup{
  show_jumps = true,
  min_jump = 2,
  popup = {
    delay_ms = 0,
    inc_ms  = 5,
    blend = 0,
    width = 50,
    winhl = "DiffAdd", --"PMenu",
    fader = require('specs').linear_fader,
    resizer = require('specs').shrink_resizer
  },
  ignore_filetyes = {},
  ignore_buftypes = {
    nofile = true,
  },
}
