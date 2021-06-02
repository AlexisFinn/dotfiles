-- should be a setting for doing this but it isn't working for some reason
vim.api.nvim_command('autocmd BufWritePost * silent! :StripWhitespace')
