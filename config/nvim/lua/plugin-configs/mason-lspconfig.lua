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
    'rust_analyzer',
    'lua_ls',
    'hls'
  }
}
