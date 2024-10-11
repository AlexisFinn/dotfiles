return {
  "mistweaverco/kulala.nvim",
  config = function()
    require("kulala").setup({
      default_view = "body", -- "headers"
      default_env = "dev",
    })
  end,
}
