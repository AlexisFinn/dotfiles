return  {
  -- 'matbme/JABS.nvim',
  'jeff-dh/expJABS.nvim',
  branch = 'expJABS',
  lazy = false,
  config = function()
    require("jabs").setup({
      -- position = {'center', 'top'},
      -- width = 90,
      -- height = 20,
      -- border = 'double',
      -- preview_position = 'right',
      -- preview = {
      --   width = 90,
      --   height = 80,
      --   border = 'double'
      -- }
    })

    local keymap = vim.api.nvim_set_keymap

    keymap('n', '<F8>', ':JABSOpen<CR>', {})
  end
}
