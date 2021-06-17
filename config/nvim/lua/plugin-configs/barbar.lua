vim.api.nvim_set_keymap('n', '<C-PageUp>', ':BufferPrevious<CR>', {})
vim.api.nvim_set_keymap('n', '<C-PageDown>', ':BufferNext<CR>', {})
vim.api.nvim_exec(
[[
  let bufferline = get(g:, 'bufferline', {})
  let bufferline.icon_custom_colors = v:true
  let bufferline.icon_separator_active = ''
  let bufferline.icon_separator_inactive = ''
]], false)
