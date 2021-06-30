local keymap = vim.api.nvim_set_keymap

keymap('n', '<leader><leader>w', ':HopWord<CR>', {})
keymap('n', '<leader><leader>l', ':HopLine<CR>', {})
keymap('n', '<leader><leader>s', ':HopPattern<CR>', {})

require 'hop'.setup{}
