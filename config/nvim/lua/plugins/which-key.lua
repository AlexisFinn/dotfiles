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
    --  ── Normal Mode ─────────────────────────────────────────────────────
    { "<C-PageDown>", "<cmd>bn<CR>", desc = "Move buffer right" },
    { "<C-PageUp>", "<cmd>bp<CR>", desc = "Move buffer left" },
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
    { "<leader>tp", function() vim.diagnostic.jump({ count = -1, float = { border = "rounded" } }) end, desc = "Go to Previous lsp error" },
    { "<leader>tn", function() vim.diagnostic.jump({ count = 1, float = { border = "rounded" } }) end, desc = "Go to Next lsp error" },
    { "<leader>tt", function() vim.diagnostic.open_float({ border = "rounded" }) end, desc = "Show current lsp error" },
    { "<leader>tr", "<cmd>LSPRestart<CR>", desc = "Restart lsp server" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write changes", remap = false },
    { "<leader>|", "<cmd>vsplit<CR>", desc = "Split window vertically" },
    {
      "<leader>cc",
      function()
        local curWord = vim.fn.escape(vim.fn.expand("<cword>"), [[\/]])
        vim.fn.search(";")
        vim.fn.execute("normal! o" .. string.format("console.log('[[ %s ]] ----------------> ', %s);", curWord, curWord))
      end,
      desc = "Add console.log for current word on next available line",
    },
  },
}