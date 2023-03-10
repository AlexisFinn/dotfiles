require("legendary").setup {
  keymaps = {
    {'<F9>', ':NvimTreeFindFileToggle<CR>', description = 'Open nvim-tree file manager', mode = {'n'}},
    {'<F10>', ':RnvimrToggle<CR>', description = 'Open ranger file manager', mode = {'n'}},
    {'<C-s>', ':noh<CR>', description = 'Remove all search highlights', mode = {'n'}},
    {'<space>S', ':split<CR>', description = 'Split window horizontally', mode = {'n'}},
    {'<space>j', '<C-W><C-J>', description = 'Focus UP', mode = {'n'}},
    {'<space>k', '<C-W><C-K>', description = 'Focus DOWN', mode = {'n'}},
    {'<space>l', '<C-W><C-L>', description = 'Focus RIGHT', mode = {'n'}},
    {'<space>h', '<C-W><C-H>', description = 'Focus LEFT', mode = {'n'}},
    {'<space>rg', ':Telescope live_grep<CR>', description = 'Search for a word or sentence within the project', mode = {'n'}},
    {'<space>o', ':Telescope project<CR>', description = 'Search for project', mode = {'n'}},
    {'<space>p', ':Telescope find_files<CR>', description = 'Search for a file within the project', mode = {'n'}},
    {'<space>s', ':Telescope session-lens search_session<CR>', description = 'Search for a session within the saved session', mode = {'n'}},
    {'<space>q', ':q<CR>', description = 'Quit/Close window', mode = {'n'}},
    {'<space>dd', ':bd<CR>', description = 'Delete current buffer', mode = {'n'}},
    {'<space>da', ':bufdo bd<CR>', description = 'Delete all buffers', mode = {'n'}},
    {'<space>w', ':w<CR>', description = 'Write changes', mode = {'n'}},
    {'<space>c', ':call nerdcommenter#Comment("n", "toggle")<CR>', description = 'Toggle comment', mode = {'n', 'v'}},
    {'<space>[', ':SplitjoinSplit<CR>', description = 'Split code structure into multiple lines', mode = {'n'}},
    {'<space>]', ':SplitjoinJoin<CR>', description = 'Join code structure into single line', mode = {'n'}},
    {'<space>e', ':IronFocus<CR>', description = 'Launch code runner for current filetype', mode = {'n'}},
    {'<space>H', ':Legendary<CR>', description = 'Open legendary keymap/command helper', mode = {'n'}},
    {'<space>gg', ':Git<CR>', description = 'Open git fugitive', mode = {'n'}},
    {'<space>ga', ':Git add %<CR>', description = 'Git add current file to git', mode = {'n'}},
    {'<space>R', ':Telescope registers<CR>', description = 'Search through registers with Telescope', mode = {'n'}},
    {'<space>z', ':TSHighlightCapturesUnderCursor<CR>', description = 'Get highlight group of word under cursor', mode = {'n'}}
  },
  commands = {
    {':FormatJSON', '%!python -m json.tool', description = 'Format json data using python'}
  },
  funcs = {},
  autocmds = {
    {'BufEnter', ':syntax sync minlines=10000', description = 'Syntax highlighting even in large files'},
  }
}
