vim.api.nvim_set_keymap('n', '<leader><leader>w', ':HopWord<CR>', {})
vim.api.nvim_set_keymap('n', '<leader><leader>l', ':HopLine<CR>', {})
vim.api.nvim_set_keymap('n', '<leader><leader>s', ':HopPattern<CR>', {})

require('hop').setup{}
