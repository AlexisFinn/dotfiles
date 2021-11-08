local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'utilsnips' },
    { name = 'buffer' },
  },
  experimental = {
    ghost_text = true,
  }
})
