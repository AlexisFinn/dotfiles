vim.api.nvim_create_user_command("Yb", "10 split | term yarn build", {})
vim.api.nvim_set_keymap("n", "<F10>", "<cmd>Yb<CR>", { noremap = true, silent = true, desc = "Run Yarn Build" })
