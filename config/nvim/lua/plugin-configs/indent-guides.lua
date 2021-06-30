local foreground = '#2a3834'
local background = '#332b36'

require 'indent_guides'.setup({
  indent_levels = 30,
  indent_guide_size = 4,
  indent_start_level = 1,
  indent_space_guides = true,
  indent_tab_guides = false,
  indent_soft_pattern = '\\s',
  exclude_filetypes = {'help', 'dashboard', 'dashpreview', 'NvimTree', 'vista', 'sagahover'},
  even_colors = { fg = foreground, bg = background},
  off_colors = { fg = background, bg = foreground}
})
