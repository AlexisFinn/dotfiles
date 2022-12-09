-- fuzzy find files in project
local keymap = vim.api.nvim_set_keymap
local telescope = require 'telescope'

keymap('n', '<C-p>', ':Telescope find_files<CR>', {})

keymap('n', '<leader>p', ':Telescope project<CR>', { noremap = true })

-- search for string under cursor
keymap('n', '<leader>F', ':Telescope grep_string<CR>', { noremap = true })
keymap('n', '<leader>rg', ':Telescope live_grep<CR>', { noremap = true })


-- default setup, see :help telescope.setup
telescope.setup {
  defaults = {
    -- layout_strategy = 'vertical', -- see :help telescope.layout
    winblend = 10,
    prompt_prefix = ' ',
    selection_caret = ' ',
    entry_prefix = '   ',
    path_display = { "tail" },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    }
  }
}

-- load extensions into telescope
-- telescope.load_extension 'ultisnips'
telescope.load_extension 'fzf'
telescope.load_extension 'ui-select'
telescope.load_extension 'project'
telescope.load_extension 'session-lens'
