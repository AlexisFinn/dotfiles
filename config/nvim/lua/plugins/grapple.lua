return {
  "cbochs/grapple.nvim",
  opts = {
    scope = "git",
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  keys = {
    { "mf", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
    { "<F8>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
  },
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },
}
