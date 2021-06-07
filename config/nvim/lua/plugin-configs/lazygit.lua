vim.api.nvim_set_keymap("n", "lg", ":LazyGit<CR>", {noremap = true})

vim.g.lazygit_fleating_window_use_plenary = 1
vim.g.lazygit_floating_window_corner_chars = {'╭', '╮', '╰', '╯'} -- customize lazygit popup window corner characters
