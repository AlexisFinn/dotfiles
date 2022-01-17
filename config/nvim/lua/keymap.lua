local cmd = vim.cmd
local keymap = vim.api.nvim_set_keymap

-- alias dd to buffer delete (bd)
cmd 'cnoreabbrev dd bd'
-- also alow to write with uppercase W
cmd 'command! W w'

-- open File Manager with F9
--keymap('n', '<F9>', ':Vifm<CR>', {})
keymap('n', '<F9>', ':RnvimrToggle<CR>', {})

-- split window switching, just map Ctrl + J,K,L,H without having to type Crtl + W before
keymap('n', '<C-J>', '<C-W><C-J>', {noremap = true})
keymap('n', '<C-K>', '<C-W><C-K>', {noremap = true})
keymap('n', '<C-L>', '<C-W><C-L>', {noremap = true})
keymap('n', '<C-H>', '<C-W><C-H>', {noremap = true})

-- ctrl + l to remove highlights (after search typically)
keymap('n', '<C-l>', ':noh<CR>', {noremap = true})
