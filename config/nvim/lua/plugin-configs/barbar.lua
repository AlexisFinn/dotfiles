local keymap = vim.api.nvim_set_keymap

-- map Ctrl + PageUp / PageDown to previous and next buffer respectively
keymap('n', '<C-PageUp>', ':BufferPrevious<CR>', {})
keymap('n', '<C-PageDown>', ':BufferNext<CR>', {})

-- set some options for the bufferline
vim.api.nvim_set_var('bufferline', {
  icon_custom_colors = true,
  icon_separator_active = '▐▬▶',
  icon_separator_inactive = '▎'
})
