return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    {
      'williamboman/mason.nvim',
      build = ':MasonUpdate',
      config = function()
        require("mason").setup()
      end
    },
    'neovim/nvim-lspconfig'
  },
  config = function()
    require('mason-lspconfig').setup {
      ensure_installed = {
        'html',
        'dockerls',
        'intelephense',
        'phpactor@2022.11.12',
        'pylsp',
        'vuels',
        'eslint',
        'tsserver',
        'yamlls',
        'stylelint_lsp',
        'gopls',
        'lua_ls'
      }
    }
  end
}
