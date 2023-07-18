-- set respectively style for current word then highlighted matches
vim.api.nvim_set_hl(0, 'IlluminatedWordText', {
  bold = true,
  standout = true,
  italic = true
})
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', {
  bold = true,
  standout = true,
  italic = true
})
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', {
  bold = true,
  standout = true,
  italic = true
})

vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_set_hl(0, 'IlluminatedWordText', {
      bold = true,
      standout = true,
      italic = true
    })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', {
      bold = true,
      standout = true,
      italic = true
    })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', {
      bold = true,
      standout = true,
      italic = true
    })
  end
})

-- vim.api.nvim_exec([[
-- augroup illuminate_augroup
--     autocmd!
--     autocmd VimEnter * hi illuminatedCurWord cterm=italic gui=italic
--     autocmd VimEnter * hi illuminatedWord cterm=italic,bold gui=italic,bold
-- augroup END
-- ]], false)
