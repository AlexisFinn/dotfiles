vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  callback = function() vim.cmd("vert copen 50") end,
})
local actions = require("telescope.actions")

local path_display_function = function(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return tail
  end
  -- return string.format("%s", "hello")
  return string.format("%s\t\t%s", tail, parent)
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
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
        border = false,
        initial_mode = "insert",
        -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        layout_strategy = "horizontal",
        layout_config = {
          height = { padding = 0 },
          width = { padding = 0 },
          -- horizontal = {
          --   preview_width = 120,
          -- },
        },
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["<C-d>"] = actions.delete_buffer,
          },
        },
        path_display = path_display_function,
      },
      colorscheme = {
        -- theme = "vertical",
        layout_strategy = "vertical",
        border = false,
        initial_mode = "normal",
        enable_preview = true,
        layout_config = {
          height = 0.8,
          preview_height = 0.7,
        },
      },
      grep_string = {
        theme = "dropdown",
        border = false,
        initial_mode = "normal",
        layout_config = {
          height = 0.5,
        },
      },
      live_grep = {
        theme = "dropdown",
        border = false,
        layout_config = {
          height = 0.5,
        },
        mappings = {
          i = {
            ["<C-l>"] = {
              actions.smart_send_to_qflist,
              -- type = "action",
            },
          },
        },
        path_display = path_display_function,
      },
      marks = {
        theme = "dropdown",
        border = false,
        enable_preview = true,
        layout_strategy = "vertical",
        layout_config = {
          height = 0.6,
        },
      },
      find_files = {
        border = false,
        path_display = { "truncate" },
      },
    },
  },
  keys = {
    { "<leader>R", function() require("telescope.builtin").registers() end, desc = "Search through registers with Telescope" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Grep current word or selection in project" },
    { "<leader>p", function() require("telescope.builtin").find_files() end, desc = "Search for a file within the project" },
    { "<leader>rg", function() require("telescope.builtin").live_grep() end, desc = "Search for a word or sentence withen the project files" },
    { "<leader>o", function() require("telescope").extensions.project.project() end, desc = "Search for project" },
    { "<F8>", function() require("telescope.builtin").buffers() end, desc = "Buffer switcher/manager" },
  },
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-project.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  extensions = { "fzf", "ui-select", "project", "smart_open" },
}
