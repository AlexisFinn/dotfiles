local cmd = vim.cmd
local keymap = vim.api.nvim_set_keymap

-- alias dd to buffer delete (bd)
cmd 'cnoreabbrev dd bd'
-- also alow to write with uppercase W
cmd 'command! W w'

-- open File Manager with F9 or <space> m
--keymap('n', '<F9>', ':Vifm<CR>', {})
keymap('n', '<F9>', ':NvimTreeFindFileToggle<CR>', {})
keymap('n', '<space>m', ':NvimTreeFindFileToggle<CR>', {})
keymap('n', '<F10>', ':RnvimrToggle<CR>', {})

-- split window switching, just map Ctrl + J,K,L,H without having to type Crtl + W before
keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })

-- ctrl + l to remove highlights (after search typically)
keymap('n', '<C-s>', ':noh<CR>', { noremap = true })

-- telescope
keymap('n', '<space>f', ':Telescope grep_string<CR>', { noremap = true }) -- same as ctrl+p function but using telescope
keymap('n', '<space>rg', ':Telescope live_grep<CR>', { noremap = true })
keymap('n', '<space>o', ':Telescope project<CR>', {})
keymap('n', '<space>p', ':Telescope find_files<CR>', {})



-- vim-fugitive
-- alias git diff
cmd 'cnoreabbrev diff Gdiffsplit'
cmd 'cnoreabbrev vdiff Gvdiffsplit'
