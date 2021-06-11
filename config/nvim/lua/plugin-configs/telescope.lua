-- fuzzy find files in project
--vim.api.nvim_set_keymap('n', '<C-p>', ':Telescope find_files<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<CR>', { noremap = true})
-- live grep for string in project
vim.api.nvim_set_keymap('n', '<leader>rg', ':Telescope live_grep<CR>', { noremap = true})
-- search for string under cursor
vim.api.nvim_set_keymap('n', '<leader>F', ':Telescope grep_string<CR>', { noremap = true})

-- default setup
require('telescope').setup{
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
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 80, -- default = 120
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '═', '│', '═', '│', '╒', '╕', '╛', '╘' },
    --borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}

-- load in utilsnips to telescope
require('telescope').load_extension('ultisnips')

