vim.cmd('autocmd BufWritePost * FormatWrite')
--vim.g.format_debug = true

require("format").setup {
  javascript = {
    {cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}}
  },
  typescript = {
    {cmd = {"prettier --parser typescript -w"}}
  },
  vue = {
    {cmd = {"prettier --parser vue -w"}}
  },
  scss = {
    {cmd = {"prettier --parser scss -w"}}
  },
  css = {
    {cmd = {"prettier --parser css -w"}}
  },
  yaml = {
    {cmd = {"prettier --parser yaml -w"}}
  },
  html = {
    {cmd = {"prettier --parser html -w"}}
  },
  haskell = {
    {cmd = {"hindent"}}
  },
  python = {
    {cmd = {"autopep8 --ignore E501"}}
  },
  php = {
    {cmd = {"php-cs-fixer fix"}}
  },
  go = {
    {cmd = {"goimports -w"}}
  },
  rust = {
    {cmd = {"rustfmt"}}
  }
}
