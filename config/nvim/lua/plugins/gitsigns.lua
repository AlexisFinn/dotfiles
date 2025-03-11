return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {
    signs = {
      add = { text = "++" },
      change = { text = "<>" },
      delete = { text = "--" },
      untracked = { text = "?" },
    },
  },
  keys = {
    { "<leader>gb", "<cmd>Gitsigns blame<CR>", desc = "Show Git blame" },
    { "<leader>ghN", "<cmd>Gitsigns prev_hunk<CR>", desc = "Git goto previous hunk" },
    { "<leader>ghn", "<cmd>Gitsigns next_hunk<CR>", desc = "Git goto next hunk" },
    { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git preview hunk diff" },
    { "<leader>ghs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Git stage current hunk" },
    { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<CR>", desc = "Git undo current hunk" },
  },
}
