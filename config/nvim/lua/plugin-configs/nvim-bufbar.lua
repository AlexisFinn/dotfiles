require('bufbar').setup {
  show_bufname = 'all'
}

local keymap = vim.api.nvim_set_keymap

keymap('n', '<C-PageUp>', ':bp<CR>', {noremap = true})
keymap('n', '<C-PageDown>', ':bn<CR>', {noremap = true})
