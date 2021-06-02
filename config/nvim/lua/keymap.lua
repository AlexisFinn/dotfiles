-- alias dd to buffer delete (bd)
vim.api.nvim_command('cnoreabbrev dd bd')
-- also alow to write with uppercase W
vim.api.nvim_command('command! W w')
vim.api.nvim_set_keymap('n', '<F9>', ':Vifm<CR>', {})
-- split window switching, just map Ctrl + J,K,L,H without having to type Crtl + W before
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', {noremap = true})
