require 'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  context_commentstring = {
    enable = true
  },
  highlight = {
    enable = false,
    additional_vim_regex_highlighting = {'org'}
  },
  rainbow = {
    enable = true
  }
}
