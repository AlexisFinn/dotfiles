return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      border = "rounded", -- none, single, double, shadow
    },
    layout = {
      height = { min = 4, max = 20 },
    },
  },
  keys = {
    --  ── Visual Mode ─────────────────────────────────────────────────────
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep current word or selection in project", mode = "v" },
    { "<leader>q", "<cmd>q<CR>", desc = "Quit/Close window", mode = "v" },
    { "<PageDown>", "<C-u>", desc = "Scroll down one page", mode = "v" },
    { "<PageUp>", "<C-d>", desc = "Scroll up one page", mode = "v" },
    --  ── Normal Mode ─────────────────────────────────────────────────────
    { "<C-PageDown>", "<cmd>bn<CR>", desc = "Move buffer right" },
    { "<C-PageUp>", "<cmd>bp<CR>", desc = "Move buffer left" },
    { "<PageDown>", "<C-u>", desc = "Scroll down one page" },
    { "<PageUp>", "<C-d>", desc = "Scroll up one page" },
    { "<C-s>", "<cmd>noh<CR>", desc = "Remove all search highlights" },
    { "<leader>-", "<cmd>split<CR>", desc = "Split window horizontally" },
    { "<leader>W", "<cmd>wa<CR>", desc = "Write All changes" },
    { "<leader>dA", "<cmd>%bd<CR>", desc = "Delete all buffers" },
    { "<leader>da", "<cmd>%bd|e#|bd#<CR>", desc = "Delete all other buffers", silent = true },
    { "<leader>dd", "<cmd>bd<CR>", desc = "Delete current buffer", silent = true },
    { "<leader>dl", "<cmd>e#<CR>", desc = "Switch to last buffer", silent = true },
    { "<leader>ga", "<cmd>!git add %<CR>", desc = "Add current file to git commit" },
    { "<leader>h", "<C-W><C-H>", desc = "Focus Window LEFT" },
    { "<leader>j", "<C-W><C-J>", desc = "Focus Window UP" },
    { "<leader>k", "<C-W><C-K>", desc = "Focus Window DOWN" },
    { "<leader>l", "<C-W><C-L>", desc = "Focus Window RIGHT" },
    { "<leader>q", "<cmd>q<CR>", desc = "Quit/Close window" },
    { "<leader>tp", function() vim.diagnostic.goto_prev() end, desc = "Go to Previous lsp error" },
    { "<leader>tn", function() vim.diagnostic.goto_next() end, desc = "Go to Previous lsp error" },
    { "<leader>tt", function() vim.diagnostic.open_float({ border = "rounded" }) end, desc = "Show current lsp error" },
    {
      "<leader>ta",
      function() vim.diagnostic.setqflist() end,
      desc = "Show all current buffer diagnostics",
    },
    { "<leader>tr", "<cmd>LspRestart<CR>", desc = "Restart lsp server" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write changes", remap = false },
    { "<leader>|", "<cmd>vsplit<CR>", desc = "Split window vertically" },
    {
      "<leader>ct",
      function()
        local curWord = vim.fn.escape(vim.fn.expand("<cword>"), [[\/]])
        vim.fn.search(";\\|{")
        vim.fn.execute("normal! o" .. string.format("console.trace(%s);", curWord))
      end,
      desc = "Add console.log for current word on next available line",
    },
    {
      "<leader>cc",
      function()
        vim.fn.execute("normal! oconsole.log();")
        vim.fn.search(")", "be")
        vim.cmd("startinsert")
      end,
      desc = "Add console log on next available line",
    },
    {
      "<leader>cp",
      function()
        local currentPos = vim.fn.getpos(".")
        local found = vim.fn.search("console\\.")
        while found > 0 do
          vim.fn.execute("normal! dd")
          found = vim.fn.search("console\\.")
        end
        vim.fn.setpos(".", currentPos)
      end,
      desc = "Purge/Clear all console.log statements in current buffer",
    },
  },
}
