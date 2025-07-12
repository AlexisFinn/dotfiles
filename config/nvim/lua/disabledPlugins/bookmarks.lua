return {
  "heilgar/bookmarks.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  config = function()
    local autocmds = require("bookmarks.autocmds")
    local navigation = require("bookmarks.navigation")
    local commands = require("bookmarks.commands")
    local map = vim.keymap.set
    require("bookmarks").setup({
      default_mappings = false,
    })
    require("telescope").load_extension("bookmarks")
    -- custom mappings using plugin api
    map("n", "mm", function()
      local bufnr = commands.add_bookmark()
      autocmds.refresh_buffer(bufnr)
    end, { desc = "Bookmark current line" })
    map("n", "mr", function()
      local bufnr = commands.remove_bookmark()
      autocmds.refresh_buffer(bufnr)
    end, { desc = "Remove current Bookmark" })
    map("n", "mn", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local bookmarks = autocmds.get_buffer_bookmarks(bufnr)
      navigation.jump_to_next(bookmarks)
      autocmds.refresh_buffer(bufnr)
    end, { desc = "Go to next Bookmark in current file" })
    map("n", "mp", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local bookmarks = autocmds.get_buffer_bookmarks(bufnr)
      navigation.jump_to_prev(bookmarks)
      autocmds.refresh_buffer(bufnr)
    end, { desc = "Go to previous Bookmark in current file" })
    map("n", "ml", require("telescope").extensions.bookmarks.list, { desc = "List all Bookmarks" })
  end,
}
