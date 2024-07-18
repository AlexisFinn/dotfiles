return {
  "declancm/cinnamon.nvim",
  config = function()
    require("cinnamon").setup({
      keymaps = {
        basic = true,
        extra = true,
      },
      options = {
        delay = 4,
      },
    })
  end,
}
