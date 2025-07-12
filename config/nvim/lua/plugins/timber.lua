return {
  "Goose97/timber.nvim",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("timber").setup({
      log_templates = {
        default = {
          javascript = [[
            console.log("----------------------- > %log_target");
            console.dir(%log_target, {depth: 5});
            console.log("----------------------- <");
          ]],
        },
      },
      keymaps = {
        insert_log_below = "<leader>cl",
        insert_log_above = "<leader>cL",
      },
    })
  end,
}
