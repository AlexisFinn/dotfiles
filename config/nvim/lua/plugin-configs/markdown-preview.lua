return {
  'iamcco/markdown-preview.nvim',
  build = function () vim.fn["mkdp#util#install"]() end,
  ft = { 'markdown' },
  cmd = {'MarkdownPreviewToggle', 'MarkdownPreviewStop', 'MarkdownPreview' },
  config = function()
    vim.g.mkdp_browser = 'google-chrome-stable'
    vim.g.mkdp_port = '4433'
  end
}
