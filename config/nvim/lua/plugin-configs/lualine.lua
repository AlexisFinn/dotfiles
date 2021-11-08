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
    theme = 'material-nvim',
    component_separators = {"", ""},
    section_separators = {"", ""},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {diagnosticMessage},
    lualine_x = {'filetype'},
    lualine_y = {},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive'}
})

