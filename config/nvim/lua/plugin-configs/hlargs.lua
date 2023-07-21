return {
  'm-demare/hlargs.nvim',
  config = function()
    require('hlargs').setup {
      color = '#47b8b3',
      disable = function(_, bufnr)
        -- disable if already determined to be disabled
        if vim.b.semantic_tokens then
          return true
        end
        -- for each buffer lsp client check if it has semantic token highlighting capabilities
        -- if it does not fallback to treesitter + hlargs
        local clients = vim.lsp.get_active_clients { bufnr = bufnr }
        for _, c in pairs(clients) do
          local caps = c.server_capabilities
          if c.name ~= "null-ls" and caps.semanticTokensProvider and caps.semanticTokensProvider.full then
            vim.b.semantic_tokens = true
            return vim.b.semantic_tokens
          end
        end
      end
    }
  end
}
