return  {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    require('mini.completion').setup({
      window = {
        info = {border = 'rounded'},
        signature = {border = 'rounded'},
      }
    })
  end
}
