return {
  "folke/which-key.nvim",
  lazy = false,
  config = function()
    local telescope = require("telescope.builtin")
    local telescopeExt = require("telescope").extensions
    local cmd = vim.cmd
    local float = vim.cmd.FloatermNew

    require("which-key").setup({
      win = {
        border = "rounded", -- none, single, double, shadow
      },
      layout = {
        height = { min = 4, max = 20 },
      },
    })

    -- ### VISUAL MODE ###
    require("which-key").add({
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep current word or selection in project", mode = "v" },
      { "<leader>q", "<cmd>q<CR>", desc = "Quit/Close window", mode = "v" },
    })

    -- ### NORMAL MODE ###
    require("which-key").add({
      { "<C-PageDown>", "<cmd>bn<CR>", desc = "Move buffer right" },
      { "<C-PageUp>", "<cmd>bp<CR>", desc = "Move buffer left" },
      { "<C-s>", "<cmd>noh<CR>", desc = "Remove all search highlights" },
      { "<F8>", function() require("snipe").open_buffer_menu({ max_path_width = 3 }) end, desc = "Buffer switcher" },
      -- { "<F8>", function() require("reach").buffers({ show_current = true }) end, desc = "Buffer switcher" },
      { "<F9>", function() require("oil").open() end, desc = "Oil file manager" },
      { "<leader>-", "<cmd>split<CR>", desc = "Split window horizontally" },
      { "<leader>L", "<cmd>Lazy<CR>", desc = "Open Lazy plugin manager" },
      { "<leader>R", function() telescope.registers() end, desc = "Search through registers with Telescope" },
      { "<leader>W", "<cmd>wa<CR>", desc = "Write All changes" },
      { "<leader>Z", "<cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Get nvim highlight group of word under cursor" },
      { "<leader>[", "<cmd>SplitjoinSplit<CR>", desc = "Split code structure into multiple lines" },
      { "<leader>]", "<cmd>SplitjoinJoin<CR>", desc = "Join code structure into single line" },
      { "<leader>d", group = "buffer(s)" },
      { "<leader>dA", "<cmd>%bd<CR>", desc = "Delete all buffers" },
      { "<leader>da", "<cmd>%bd|e#|bd#<CR>", desc = "Delete all other buffers", silent = true },
      { "<leader>dd", "<cmd>bd<CR>", desc = "Delete current buffer", silent = true },
      { "<leader>dl", "<cmd>e#<CR>", desc = "Switch to last buffer", silent = true },
      {
        "<leader>e",
        function()
          float({
            args = {
              "--width=0.8",
              "--height=0.8",
              "--title=NodeJS",
              "--titleposition=right",
              "node",
            },
          })
        end,
        desc = "Launch Node runner",
      },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep current word or selection in project" },
      { "<leader>g", group = "git" },
      { "<leader>ga", "<cmd>!git add %<CR>", desc = "Add current file to git commit" },
      { "<leader>gb", "<cmd>Gitsigns blame<CR>", desc = "Show Git blame" },
      {
        "<leader>gg",
        function()
          float({
            args = {
              "--width=1.0",
              "--height=1.0",
              "--title=LazyGit",
              "--titleposition=right",
              "lazygit",
            },
          })
        end,
        desc = "Open LazyGit",
      },
      { "<leader>gh", group = "git hunk" },
      { "<leader>ghN", "<cmd>Gitsigns prev_hunk<CR>", desc = "Git goto previous hunk" },
      { "<leader>ghn", "<cmd>Gitsigns next_hunk<CR>", desc = "Git goto next hunk" },
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git preview hunk diff" },
      { "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Git stage current hunk" },
      { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Git undo current hunk" },
      { "<leader>h", "<C-W><C-H>", desc = "Focus Window LEFT" },
      { "<leader>j", "<C-W><C-J>", desc = "Focus Window UP" },
      { "<leader>k", "<C-W><C-K>", desc = "Focus Window DOWN" },
      { "<leader>l", "<C-W><C-L>", desc = "Focus Window RIGHT" },
      { "<leader>o", function() telescopeExt.project.project() end, desc = "Search for project" },
      { "<leader>p", function() telescope.find_files() end, desc = "Search for a file within the project" },
      { "<leader>q", "<cmd>q<CR>", desc = "Quit/Close window" },
      { "<leader>r", group = "RipGrep" },
      { "<leader>rg", function() telescope.live_grep() end, desc = "Search for a word or sentence withen the project files" },
      { "<leader>s", function() require("auto-session.session-lens").search_session() end, desc = "Search fo a session within saved sessions" },
      { "<leader>t", group = "Lsp" },
      { "<leader>tN", function() vim.diagnostic.goto_prev({ float = { border = "rounded" } }) end, desc = "Go to Previous lsp error" },
      { "<leader>tn", function() vim.diagnostic.goto_next({ float = { border = "rounded" } }) end, desc = "Go to Next lsp error" },
      { "<leader>tr", function() vim.diagnostic.open_float({ border = "rounded" }) end, desc = "Restart lsp server" },
      { "<leader>tt", "<cmd>LSPRestart<CR>", desc = "Show current lsp error" },
      { "<leader>w", "<cmd>w<cr>", desc = "Write changes", remap = false },
      { "<leader>|", "<cmd>vsplit<CR>", desc = "Split window vertically" },
      { "m", group = "Bookmarks" },
      -- { "ma", "<cmd>BookmarkShowAll<CR>", desc = "Show all bookmarks" },
      -- { "mc", "<cmd>BookmarkClear<CR>", desc = "Clear all bookmarks in current buffer" },
      -- { "mi", "<cmd>BookmarkAnnotate<CR>", desc = "Add/Remove/Edit annotation on current line" },
      -- { "mm", "<cmd>BookmarkToggle<CR>", desc = "Toggle bookmark on current line" },
      -- { "mn", "<cmd>BookmarkNext<CR>", desc = "Go to next bookmark" },
      -- { "mp", "<cmd>BookmarkPrev<CR>", desc = "Go to previous bookmark" },
      -- { "mx", "<cmd>BookmarkClearAll<CR>", desc = "Clear all bookmarks in current project" },
    })
  end,
}
