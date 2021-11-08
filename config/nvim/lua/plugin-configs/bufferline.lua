require("bufferline").setup{
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    always_show_bufferline = false
  }
}

local keymap = vim.api.nvim_set_keymap

keymap('n', '<C-PageUp>', ':BufferLineCyclePrev<CR>', {noremap = true})
keymap('n', '<C-PageDown>', ':BufferLineCycleNext<CR>', {noremap = true})
