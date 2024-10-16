return   {
  'folke/trouble.nvim',
  config = function ()
    require 'trouble'.setup{
      auto_open = false,
      auto_close = true
    }
  end
}
