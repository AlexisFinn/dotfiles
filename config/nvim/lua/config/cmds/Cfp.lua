-- copy selected code with file ref:
--   /the/name/of/the/file:line_number
--   ```
--   selected code
--   ```
vim.api.nvim_create_user_command("Cfp", function()
    local fp = vim.fn.expand("%")
    local cwd = vim.fn.getcwd()
    local relpath = string.gsub(fp, cwd .. "/", "")

    vim.fn.setreg("*", relpath)
    vim.fn.setreg("+", relpath)
end, {range = true, nargs = 0})
