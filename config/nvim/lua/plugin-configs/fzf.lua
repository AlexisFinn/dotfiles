local keymap = vim.api.nvim_set_keymap

-- CtrlP search using fzf
keymap('n', '<C-p>', ":lua require('fzf-commands').files()<cr>", {})
