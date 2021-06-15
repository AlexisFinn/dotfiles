vim.api.nvim_set_keymap('n', '<C-PageUp>', ':bn<CR>', {})
vim.api.nvim_set_keymap('n', '<C-PageDown>', ':bp<CR>', {})
vim.g.vem_tabline_show = 2 -- 0: never show, 1: show when more than one tab or buffer open, 2: always show
vim.api.nvim_exec([[
  hi VemTablineSelected guifg=Black guibg=SkyBlue
  hi VemTablineShown guifg=Black guibg=SkyBlue
]], false)

