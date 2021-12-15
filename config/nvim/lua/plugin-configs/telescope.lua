-- fuzzy find files in project
local keymap = vim.api.nvim_set_keymap
local telescope = require 'telescope'

keymap('n', '<C-p>', ':Telescope find_files<CR>', {})
keymap('n', '<leader>f', ':Telescope find_files<CR>', { noremap = true}) -- same as ctrl+p function but using telescope
-- live grep for string in project
keymap('n', '<leader>rg', ':Telescope live_grep<CR>', { noremap = true})
-- search for string under cursor
keymap('n', '<leader>F', ':Telescope grep_string<CR>', { noremap = true})

-- default setup, see :help telescope.setup
telescope.setup{
  defaults = {
    -- layout_strategy = 'vertical', -- see :help telescope.layout
    winblend = 10,
    prompt_prefix = ' ',
    selection_caret = ' ',
    entry_prefix = '   ',
    path_display = {"tail"},
  }
}

-- load extensions into telescope
-- telescope.load_extension 'ultisnips'
telescope.load_extension 'fzf'
