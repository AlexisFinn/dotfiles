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
      { "<leader>fw", function() cmd("Telescope grep_string") end, desc = "Grep current word or selection in project", mode = "v" },
      { "<leader>q", "<cmd>q<CR>", desc = "Quit/Close window", mode = "v" },
    })

    -- ### NORMAL MODE ###
    require("which-key").add({
      { "<C-PageDown>", function() cmd("bn") end, desc = "Move buffer right" },
      { "<C-PageUp>", function() cmd("bp") end, desc = "Move buffer left" },
      { "<C-s>", function() cmd("noh") end, desc = "Remove all search highlights" },
      { "<F8>", function() require("reach").buffers({ show_current = true }) end, desc = "Buffer switcher" },
      { "<F9>", function() require("oil").open() end, desc = "Oil file manager" },
      { "<leader>-", function() cmd("split") end, desc = "Split window horizontally" },
      { "<leader>L", function() cmd("Lazy") end, desc = "Open Lazy plugin manager" },
      { "<leader>R", function() telescope.registers() end, desc = "Search through registers with Telescope" },
      { "<leader>W", function() cmd("wa") end, desc = "Write All changes" },
      { "<leader>Z", function() cmd("TSHighlightCapturesUnderCursor") end, desc = "Get nvim highlight group of word under cursor" },
      { "<leader>[", function() cmd("SplitjoinSplit") end, desc = "Split code structure into multiple lines" },
      { "<leader>]", function() cmd("SplitjoinJoin") end, desc = "Join code structure into single line" },
      { "<leader>d", group = "buffer(s)" },
      { "<leader>dA", function() cmd("%bd") end, desc = "Delete all buffers" },
      { "<leader>da", function() cmd("%bd|e#|bd#") end, desc = "Delete all other buffers" },
      { "<leader>dd", "<cmd>bd<CR>", desc = "Delete current buffer" },
      { "<leader>dl", function() cmd("e#") end, desc = "Switch to last buffer" },
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
      { "<leader>fw", function() cmd("Telescope grep_string") end, desc = "Grep current word or selection in project" },
      { "<leader>g", group = "git" },
      { "<leader>ga", function() cmd("Git add %") end, desc = "Add current file to git commit" },
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
      { "<leader>ghN", function() cmd("Gitsigns prev_hunk") end, desc = "Git goto previous hunk" },
      { "<leader>ghn", function() cmd("Gitsigns next_hunk") end, desc = "Git goto next hunk" },
      { "<leader>ghp", function() cmd("Gitsigns preview_hunk") end, desc = "Git preview hunk diff" },
      { "<leader>ghs", function() cmd("Gitsigns stage_hunk") end, desc = "Git stage current hunk" },
      { "<leader>ghu", function() cmd("Gitsigns undo_stage_hunk") end, desc = "Git undo current hunk" },
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
      { "<leader>tt", function() cmd("LSPRestart") end, desc = "Show current lsp error" },
      { "<leader>w", "<cmd>w<cr>", desc = "Write changes", remap = false },
      { "<leader>|", function() cmd("vsplit") end, desc = "Split window vertically" },
      { "m", group = "Bookmarks" },
      { "ma", function() cmd("BookmarkShowAll") end, desc = "Show all bookmarks" },
      { "mc", function() cmd("BookmarkClear") end, desc = "Clear all bookmarks in current buffer" },
      { "mi", function() cmd("BookmarkAnnotate") end, desc = "Add/Remove/Edit annotation on current line" },
      { "mm", function() cmd("BookmarkToggle") end, desc = "Toggle bookmark on current line" },
      { "mn", function() cmd("BookmarkNext") end, desc = "Go to next bookmark" },
      { "mp", function() cmd("BookmarkPrev") end, desc = "Go to previous bookmark" },
      { "mx", function() cmd("BookmarkClearAll") end, desc = "Clear all bookmarks in current project" },
    })
  end,
}
