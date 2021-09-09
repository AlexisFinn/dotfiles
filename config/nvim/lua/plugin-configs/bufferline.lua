require("bufferline").setup{}

local keymap = vim.api.nvim_set_keymap

keymap('n', '<C-PageUp>', ':BufferLineCyclePrev<CR>', {noremap = true})
keymap('n', '<C-PageDown>', ':BufferLineCycleNext<CR>', {noremap = true})
