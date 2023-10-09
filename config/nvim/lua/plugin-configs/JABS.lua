return  {
  -- 'matbme/JABS.nvim',
  'jeff-dh/expJABS.nvim',
  branch = 'expJABS',
  lazy = false,
  config = function()
    require("jabs").setup({
      position = {'center', 'center'},
      width = 70,
      height = 20,
      border = 'single',
      sort_mru = true,
      preview_position = 'bottom',
      preview = {
        width = 70,
        height = 20,
        border = 'single'
      },
      keymap = {
        preview = "p"
      },
    })

    vim.keymap.set('n', '<F8>', function() vim.cmd('JABSOpen') end, {desc = 'Buffer switcher'})
  end
}
