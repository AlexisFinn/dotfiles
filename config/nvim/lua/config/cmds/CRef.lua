-- copy selected code with file ref:
--   /the/name/of/the/file:line_number
--   ```
--   selected code
--   ```
vim.api.nvim_create_user_command("CRef", function()
  local fp = vim.fn.expand("%")
  local cwd = vim.fn.getcwd()
  local relpath = string.gsub(fp, cwd .. "/", "")

  local winid = vim.api.nvim_get_current_win()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(winid))
  local ref = string.format("%s:%d", relpath, row)

  local vstart = vim.fn.getpos("'<")
  local vend = vim.fn.getpos("'>")
  local from = vstart[2] - 1
  local to = vend[2]
  local lines = vim.api.nvim_buf_get_lines(0, from, to, false)
  local fullContext = ref .. "\n```\n" .. table.concat(lines, "\n") .. "\n```\n"
  vim.fn.setreg("*", fullContext)
  vim.fn.setreg("+", fullContext)
end, { range = true, nargs = 0 })
