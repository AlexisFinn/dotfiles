local function diagnosticMessage()
  local current = vim.lsp.diagnostic.get_line_diagnostics()
  if current[1] == nil then
    return '...'
  else
    return current[1].message
  end
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'catppuccin',
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'diagnostics' },
    lualine_x = { 'fileformat' },
    lualine_y = { 'filetype' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive' }
})
