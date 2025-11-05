-- do syntax highlighting even in large files
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function() vim.cmd.syntax("sync minlines=10000") end
})

-- unfold all folds in file by default
vim.api.nvim_create_autocmd("BufEnter",
                            {callback = function() vim.cmd("normal zR") end})

-- delete old buffers, this event is triggered manually
vim.api.nvim_create_autocmd("User", {
    pattern = "DelOldBuf",
    callback = function()
        local bufs_out = vim.api.nvim_exec2("ls t", {output = true}).output
        local bufs = vim.split(bufs_out, "\n", {trimempty = true})
        if #bufs > 6 then
            local bufNum = string.match(bufs[#bufs], "[0-9]+")
            vim.api.nvim_exec2("bd " .. bufNum, {output = false})
        end
    end
})

-- hightlight yanked text for 0.1 seconds
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", {clear = true}),
    callback = function() vim.highlight.on_yank() end
})

-- trigger sessionSave on quit to trigger any events linked to it
-- eg: Arena won't save buffer list without this
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function() vim.cmd("do SessionWritePost") end
})

-- change highlight in telescope results to comments for anything after a double tab (\t\t)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", {link = "Comment"})
        end)
    end
})
-- close terminal windows automatically when the process exits
vim.api.nvim_create_autocmd("TermClose", {
    callback = function(args)
        vim.api.nvim_buf_delete(args.buf, {unload = true})
    end
})
