return  {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-project.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    -- fuzzy find files in project
    local telescope = require("telescope")

    -- default setup, see :help telescope.setup
    telescope.setup({
      defaults = {
        -- layout_strategy = 'vertical', -- see :help telescope.layout
        winblend = 10,
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "   ",
        path_display = { "tail" },
        mappings = {
          n = {
            ["q"] = require("telescope.actions").close
          }
        }
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
      pickers = {
        buffers = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        colorscheme = {
          theme = "dropdown",
          initial_mode = "normal",
          enable_preview = true,
          layout_config = {
            height = 0.7,
          }
        }
      }
    })

    -- load extensions into telescope
    -- telescope.load_extension 'ultisnips'
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("project")
    -- telescope.load_extension 'session-lens'
  end
}
