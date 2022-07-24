-- set respectively style for current word then highlighted matches
vim.api.nvim_exec([[
augroup illuminate_augroup
    autocmd!
    autocmd VimEnter * hi illuminatedCurWord cterm=italic gui=italic
    autocmd VimEnter * hi illuminatedWord cterm=italic,bold gui=italic,bold
augroup END
]], false)
