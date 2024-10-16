vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function() vim.cmd("vert copen 50") end,
})
local telescope = require("telescope")
local actions = require("telescope.actions")

return {
  "nvim-telescope/telescope.nvim",
  opts = {
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
  },
  keys = {
    { "<leader>R", function() require("telescope.builtin").registers() end, desc = "Search through registers with Telescope" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Grep current word or selection in project" },
    { "<leader>p", function() require("telescope.builtin").find_files() end, desc = "Search for a file within the project" },
    { "<leader>rg", function() require("telescope.builtin").live_grep() end, desc = "Search for a word or sentence withen the project files" },
    { "<leader>o", function() require("telescope").extensions.project.project() end, desc = "Search for project" },
  },
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-project.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  configure = function()
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("project")
    telescope.load_extension("smart_open")
  end,
}
