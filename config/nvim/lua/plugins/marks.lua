return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {
    default_mappings = true,
    cyclic = true,
    mappings = {
      -- set = "m",
      toggle = "mm",
      next = "mn",
      prev = "mp",
      preview = "mi",
      next_bookmark = "m}",
      prev_bookmark = "m{",
      -- delete_buf = "mc",
    },
  },
  keys = {
    { "<leader>ml", function() vim.cmd("MarksListAll") end, desc = "List all marks" },
  },
}
