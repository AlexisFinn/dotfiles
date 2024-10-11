vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function() vim.cmd("vert copen 50") end,
})

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-project.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    -- fuzzy find files in project
    local telescope = require("telescope")
    local actions = require("telescope.actions")

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
            ["q"] = actions.close,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
      pickers = {
        buffers = {
          theme = "dropdown",
          initial_mode = "insert",
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          layout_strategy = "vertical",
          layout_config = {
            height = 0.6,
          },
        },
        colorscheme = {
          -- theme = "vertical",
          layout_strategy = "vertical",
          initial_mode = "normal",
          enable_preview = true,
          layout_config = {
            height = 0.8,
            preview_height = 0.7,
          },
        },
        grep_string = {
          theme = "dropdown",
          initial_mode = "normal",
          layout_config = {
            height = 0.5,
          },
        },
        live_grep = {
          theme = "dropdown",
          layout_config = {
            height = 0.5,
          },
          mappings = {
            i = {
              ["<C-l>"] = {
                actions.smart_send_to_qflist,
                type = "action",
              },
            },
          },
        },
        marks = {
          theme = "dropdown",
          enable_preview = true,
          layout_strategy = "vertical",
          layout_config = {
            height = 0.6,
          },
        },
        find_files = {
          path_display = { "smart" },
        },
      },
    })

    -- load extensions into telescope
    -- telescope.load_extension 'ultisnips'
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("project")
    telescope.load_extension("smart_open")
    -- telescope.load_extension("bookmarks")
    -- telescope.load_extension 'session-lens'
  end,
}
