return {
  'ray-x/lsp_signature.nvim',
  config = function()
    require('lsp_signature').setup {
      floating_window = false, -- use virtual text instead of floating window
      bind = true,
      noice = false,
      handler_opts = {
        border = "rounded"
      }
    }
  end
}
