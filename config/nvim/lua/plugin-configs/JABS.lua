require("jabs").setup({
  position = 'corner',
  width = 90,
  height = 20,
  border = 'single',
  preview_position = 'top',
  preview = {
    width = 90,
    height = 80,
    border = 'single'
  }
})

local keymap = vim.api.nvim_set_keymap

keymap('n', '<F8>', ':JABSOpen<CR>', {})
