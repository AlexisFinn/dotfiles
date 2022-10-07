require("nvim-tree").setup({
  git = {
    enable = true,
    ignore = false
  },
  view = {
    adaptive_size = false,
    centralize_selection = true,
    width = 100,
    float = {
      enable = true,
      open_win_config = {
        relative = "editor",
        width = 120,
        height = 50
      }
    }
  }
})
