return {
  'theHamsta/nvim-dap-virtual-text',
  dependencies = {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'nvim-treesitter/nvim-treesitter'
  },
  config = function()
    require('nvim-dap-virtual-text').setup()
  end
}
