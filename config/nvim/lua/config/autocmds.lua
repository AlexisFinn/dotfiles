-- do syntax highlighting even in large files
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() vim.cmd.syntax("sync minlines=10000") end,
})
-- unfold all folds in file by default
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() vim.cmd("normal zR") end,
})

-- hylight yanked text for 0.1 seconds
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight wen yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- trigger sessionSave on quit to trigger any events linked to it
-- eg: Arena won't save buffer list without this
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function() vim.cmd("do SessionWritePost") end,
})

-- change highlight in telescope results to comments for anything after a double tab (\t\t)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})
