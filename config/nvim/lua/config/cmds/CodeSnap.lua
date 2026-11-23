-- Use CodeSnap to capture a screenshot of the selected code and copy it to the clipboard
vim.api.nvim_create_user_command("CodeSnap", function()
    local filePath = vim.fn.expand("%")
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    local from = vstart[2]
    local to = vend[2]
    local cmd = {
        "codesnap", "-f", filePath, "-o", "/tmp/image.png", "--has-line-number",
        "--mac-window-bar", "false", "--has-breadcrumbs", "true",
        "--disable-watermark", "--margin-x", "0", "--margin-y", "0", "--range",
        string.format("%d:%d", from, to)
    }
    vim.fn.jobstart(cmd, {
        on_exit = function()
            os.execute("xclip -sel clip -t image/png /tmp/image.png")
            os.remove("/tmp/image.png")
        end,
        detach = true
    })
end, {range = true, nargs = 0})
