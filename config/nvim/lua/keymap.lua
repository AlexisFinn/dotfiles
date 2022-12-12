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
keymap('n', '<space>j', '<C-W><C-J>', { noremap = true })
keymap('n', '<space>k', '<C-W><C-K>', { noremap = true })
keymap('n', '<space>l', '<C-W><C-L>', { noremap = true })
keymap('n', '<space>h', '<C-W><C-H>', { noremap = true })
keymap('n', '<space>S', ':split<CR>', { noremap = true })

-- ctrl + l to remove highlights (after search typically)
keymap('n', '<C-s>', ':noh<CR>', { noremap = true })

-- telescope
keymap('n', '<space>f', ':Telescope grep_string<CR>', { noremap = true }) -- same as ctrl+p function but using telescope
keymap('n', '<space>rg', ':Telescope live_grep<CR>', { noremap = true })
keymap('n', '<space>o', ':Telescope project<CR>', {})
keymap('n', '<space>p', ':Telescope find_files<CR>', {})
keymap('n', '<space>s', ':Telescope session-lens search_session<CR>', { noremap = true })

-- custom
keymap('n', '<space>q', ':q<CR>', {})
keymap('n', '<space>dd', ':bd<CR>', {})
keymap('n', '<space>da', ':bufdo bd<CR>', {})
keymap('n', '<space>w', ':w<CR>', {})
keymap('n', '<space>c', ':call nerdcommenter#Comment("n", "toggle")<CR>', {})
keymap('v', '<space>c', ':call nerdcommenter#Comment("n", "toggle")<CR>', {})
keymap('n', '<space>[', ':SplitjoinSplit<CR>', {})
keymap('n', '<space>]', ':SplitjoinJoin<CR>', {})
keymap('n', '<space>e', ':IronFocus<CR>', {})


-- lazygit
-- keymap('n', '<space>lg', ':LazyGit<CR>', {})
vim.keymap.set('n', '<space>lg', function ()
  cmd 'LazyGit'
end, {silent = true})

-- vim-fugitive
-- alias git diff
-- cmd 'cnoreabbrev diff Gdiffsplit'
-- cmd 'cnoreabbrev vdiff Gvdiffsplit'
