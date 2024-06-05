return {
  'stevearc/oil.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  config = function() require("oil").setup({
    columns = {
      "icon",
      "permissions",
      "size"
    },
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<Esc>"] = "actions.close",
      ["q"] = "actions.close"
    }
  }) end,
}
