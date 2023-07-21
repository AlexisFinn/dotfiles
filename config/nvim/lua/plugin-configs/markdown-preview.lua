return {
  'iamcco/markdown-preview.nvim',
  build = ':call mkdp#util#install()',
  config = function()
    vim.g.mkdp_browser = 'google-chrome-stable'
    vim.g.mkdp_port = '4433'
  end
}
