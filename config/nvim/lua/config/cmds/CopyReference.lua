-- Copy the current file's full path (with line range) to the clipboard
vim.api.nvim_create_user_command("CopyReference", function(opts)
    local path = vim.fn.expand("%:p")
    local from = opts.line1
    local to = opts.line2
    local reference = from == to and string.format("%s:%d", path, from) or
                           string.format("%s:%d-%d", path, from, to)
    vim.fn.setreg("+", reference)
    vim.notify("Copied: " .. reference)
end, {range = true, nargs = 0})

vim.keymap.set({"n", "v"}, "xr", "<cmd>CopyReference<cr>",
                {silent = true, desc = "Copy file:line reference to clipboard"})
