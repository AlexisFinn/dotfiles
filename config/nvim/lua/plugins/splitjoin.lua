return {
  "bennypowers/splitjoin.nvim",
  lazy = true,
  keys = {
    { "<leader>[", function() require("splitjoin").split() end, desc = "Split code structure into multiple lines" },
    { "<leader>]", function() require("splitjoin").join() end, desc = "Join code structure into single line" },
  },
}
