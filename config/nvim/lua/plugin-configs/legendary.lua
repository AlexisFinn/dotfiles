local telescope = require("telescope.builtin")
local telescopeExt = require("telescope").extensions
local truezen = require("true-zen")

require("legendary").setup({
  keymaps = {
    {
      "<F10>",
      function()
        vim.cmd("NvimTreeFindFileToggle")
      end,
      description = "Open nvim-tree file manager",
      mode = { "n" },
    },
    -- {'<F9>', function() vim.cmd('RnvimrToggle') end, description = 'Open ranger file manager', mode = {'n'}},
    {
      "<F9>",
      function()
        vim.cmd.FloatermNew({
          args = {
            "--width=0.9",
            "--height=0.9",
            "--title=Ranger",
            "--opener=edit",
            "--titleposition=right",
            "ranger",
            "%",
          },
        })
      end,
      description = "Open ranger file manager",
      mode = { "n" },
    },
    {
      "<C-s>",
      function()
        vim.cmd("noh")
      end,
      description = "Remove all search highlights",
      mode = { "n" },
    },
    {
      "<leader>S",
      function()
        vim.cmd("split")
      end,
      description = "Split window horizontally",
      mode = { "n" },
    },
    {
      "<leader>V",
      function()
        vim.cmd("vsplit")
      end,
      description = "Split window horizontally",
      mode = { "n" },
    },
    {
      "<leader>rg",
      function()
        telescope.live_grep()
      end,
      description = "Search for a word or sentence within the project",
      mode = { "n" },
    },
    {
      "<leader>o",
      function()
        telescopeExt.project.project()
      end,
      description = "Search for project",
      mode = { "n" },
    },
    {
      "<leader>s",
      function()
        require("auto-session.session-lens").search_session()
      end,
      description = "Search for a session within the saved session",
      mode = { "n" },
    },
    {
      "<leader>q",
      function()
        vim.cmd("q")
      end,
      description = "Quit/Close window",
      mode = { "n" },
    },
    {
      "<leader>dd",
      function()
        vim.cmd("bd")
      end,
      description = "Delete current buffer",
      mode = { "n" },
    },
    {
      "<leader>da",
      function()
        -- %bd (delete all buffers)
        -- e# (re-open last buffer)
        -- bd# (delete the empty buffer that was created in the process)
        vim.cmd("%bd|e#|bd#")
      end,
      description = "Delete all other buffers",
      mode = { "n" },
    },
    {
      "<C-PageUp>",
      function()
        vim.cmd("BufferLineCyclePrev")
      end,
      description = "Previous Buffer",
      mode = { "n" },
    },
    {
      "<C-PageDown>",
      function()
        vim.cmd("BufferLineCycleNext")
      end,
      description = "Next Buffer",
      mode = { "n" },
    },
    {
      "<leader><PageUp>",
      function()
        vim.cmd("BufferLineMovePrev")
      end,
      description = "Move buffer left",
      mode = { "n" },
    },
    {
      "<leader><PageDown>",
      function()
        vim.cmd("BufferLineMoveNext")
      end,
      description = "Move buffer right",
      mode = { "n" },
    },
    {
      "<leader>w",
      function()
        vim.cmd("w")
      end,
      description = "Write changes",
      mode = { "n" },
    },
    { "<leader>c", ":CommentToggle<cr>", description = "Toggle comment", mode = { "n", "v" } },
    {
      "<leader>[",
      function()
        vim.cmd("SplitjoinSplit")
      end,
      description = "Split code structure into multiple lines",
      mode = { "n" },
    },
    {
      "<leader>]",
      function()
        vim.cmd("SplitjoinJoin")
      end,
      description = "Join code structure into single line",
      mode = { "n" },
    },
    {
      "<leader>e",
      function()
        vim.cmd("IronFocus")
      end,
      description = "Launch code runner for current filetype",
      mode = { "n", "v" },
    },
    {
      "<leader>H",
      function()
        vim.cmd("Legendary")
      end,
      description = "Open legendary keymap/command helper",
      mode = { "n" },
    },
    {
      "<leader>gg",
      function()
        vim.cmd("Git")
      end,
      description = "Open git fugitive",
      mode = { "n" },
    },
    {
      "<leader>ga",
      function()
        vim.cmd("Git add %")
      end,
      description = "Git add current file to git",
      mode = { "n" },
    },
    {
      "<leader>ghp",
      function()
        vim.cmd("Gitsigns preview_hunk")
      end,
      description = "Git preview hunk diff",
      mode = { "n" },
    },
    {
      "<leader>ghs",
      function()
        vim.cmd("Gitsigns stage_hunk")
      end,
      description = "Git stage current hunk",
      mode = { "n" },
    },
    {
      "<leader>ghu",
      function()
        vim.cmd("Gitsigns undo_stage_hunk")
      end,
      description = "Git undo current hunk",
      mode = { "n" },
    },
    {
      "<leader>ghn",
      function()
        vim.cmd("Gitsigns next_hunk")
      end,
      description = "Git goto next hunk",
      mode = { "n" },
    },
    {
      "<leader>ghN",
      function()
        vim.cmd("Gitsigns prev_hunk")
      end,
      description = "Git goto previous hunk",
      mode = { "n" },
    },
    {
      "<leader>R",
      function()
        vim.cmd("Telescope registers")
      end,
      description = "Search through registers with Telescope",
      mode = { "n" },
    },
    {
      "<leader>Z",
      function()
        vim.cmd("TSHighlightCapturesUnderCursor")
      end,
      description = "Get highlight group of word under cursor",
      mode = { "n" },
    },
    {
      "<leader>tt",
      function()
        vim.diagnostic.open_float({ border = "rounded" })
      end,
      description = "Show Current lsp error",
      mode = { "n" },
    },
    {
      "<leader>tn",
      function()
        vim.diagnostic.goto_next({ float = { border = "rounded" } })
      end,
      description = "Go to Next lsp error",
      mode = { "n" },
    },
    {
      "<leader>tN",
      function()
        vim.diagnostic.goto_prev({ float = { border = "rounded" } })
      end,
      description = "Go to Previous lsp error",
      mode = { "n" },
    },
    {
      "<leader>p",
      function()
        telescope.find_files()
      end,
      description = "Search for a file within the project",
      mode = { "n" },
    },
    {
      "mm",
      function()
        vim.cmd("BookmarkToggle")
      end,
      description = "Toggle bookmark on current line",
      mode = { "n" },
    },
    {
      "mi",
      function()
        vim.cmd("BookmarkAnnotate")
      end,
      description = "Add/Remove/Edit annotation on current line",
      mode = { "n" },
    },
    {
      "mn",
      function()
        vim.cmd("BookmarkNext")
      end,
      description = "Go to next bookmark",
      mode = { "n" },
    },
    {
      "ma",
      function()
        vim.cmd("BookmarkShowAll")
      end,
      description = "Show all bookmarks",
      mode = { "n" },
    },
    {
      "mc",
      function()
        vim.cmd("BookmarkClear")
      end,
      description = "Clear all bookmarks in current buffer",
      mode = { "n" },
    },
    {
      "mx",
      function()
        vim.cmd("BookmarkClearAll")
      end,
      description = "Clear all bookmarks in all buffers",
      mode = { "n" },
    },
    { "<leader>j", "<C-W><C-J>", description = "Focus Window UP", mode = { "n" } },
    { "<leader>k", "<C-W><C-K>", description = "Focus Window DOWN", mode = { "n" } },
    { "<leader>l", "<C-W><C-L>", description = "Focus Window RIGHT", mode = { "n" } },
    { "<leader>h", "<C-W><C-H>", description = "Focus Window LEFT", mode = { "n" } },
    {
      "<leader>zn",
      function()
        local first = vim.fn.line("v")
        local last = vim.fn.line(".")
        truezen.narrow(first, last)
      end,
      description = "Toggle selection Focus",
      mode = { "v" },
    },
    {
      "<leader>zf",
      function()
        truezen.focus()
      end,
      description = "Toggle window Focus",
      mode = { "n" },
    },
    {
      "<leader>zm",
      function()
        truezen.minimalist()
      end,
      description = "Toggle minimalist Focus mode",
      mode = { "n" },
    },
    {
      "<leader>za",
      function()
        truezen.ataraxis()
      end,
      description = "Toggle window Zoom Focus mode",
      mode = { "n" },
    },
  },
  commands = {
    { ":FormatJSON", "%!python -m json.tool", description = "Format json data using python" },
  },
  funcs = {},
  autocmds = {
    { "BufEnter", ":syntax sync minlines=10000", description = "Syntax highlighting even in large files" },
  },
})