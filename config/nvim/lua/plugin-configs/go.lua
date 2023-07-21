return  {
  'ray-x/go.nvim',
  dependencies = {
    {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter'
  },
  config = function()
    require('go').setup{}
  end,
}
