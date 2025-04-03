return {
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = { "Bilal2453/luvit-meta", lazy = true },
  opts = {
    enabled = true,
    library = {
      "LazyVim",
      -- { path = "luvit-meta/library", words = { "vim%.uv" } },
      "luvit-meta/library",
    },
  },
}
