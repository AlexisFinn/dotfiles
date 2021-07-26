-- fuzzy find files in project
local keymap = vim.api.nvim_set_keymap
local telescope = require 'telescope'

--keymap('n', '<C-p>', ':Telescope find_files<CR>', {}) -- I prefer using fzf for ctrl+p functionality
keymap('n', '<leader>f', ':Telescope find_files<CR>', { noremap = true}) -- same as ctrl+p function but using telescope
-- live grep for string in project
keymap('n', '<leader>rg', ':Telescope live_grep<CR>', { noremap = true})
-- search for string under cursor
keymap('n', '<leader>F', ':Telescope grep_string<CR>', { noremap = true})

-- default setup
telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
      with = 0.75,
      height = 1,
      prompt_position = "bottom",
      preview_cutoff = 80, -- default = 120
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = true,
    winblend = 0,
    border = {},
    borderchars = { '═', '│', '═', '│', '╒', '╕', '╛', '╘' },
    --borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }, -- default
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}

-- load in utilsnips to telescope
telescope.load_extension 'ultisnips'

