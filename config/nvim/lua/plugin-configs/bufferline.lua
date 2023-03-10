require("bufferline").setup{
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    always_show_bufferline = true
  }
}

local keymap = vim.api.nvim_set_keymap

keymap('n', '<C-PageUp>', ':BufferLineCyclePrev<CR>', {noremap = true})
keymap('n', '<C-PageDown>', ':BufferLineCycleNext<CR>', {noremap = true})
keymap('n', '<space><PageUp>', ':BufferLineMovePrev<CR>', {noremap = true})
keymap('n', '<space><PageDown>', ':BufferLineMoveNext<CR>', {noremap = true})
