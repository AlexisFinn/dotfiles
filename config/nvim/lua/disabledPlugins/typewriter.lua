return {
  "joshuadanpeterson/typewriter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function() require("typewriter").setup() end,
  opts = {
    enabled = true,
    enable_horizontal_scroll = true,
  },
}
