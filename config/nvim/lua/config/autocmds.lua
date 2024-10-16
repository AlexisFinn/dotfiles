-- do syntax highlighting even in large files
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() vim.cmd.syntax("sync minlines=10000") end,
})
-- unfold all folds in file by default
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() vim.cmd("normal zR") end,
})

-- hilite yanked text for 0.1 seconds
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight wen yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})
