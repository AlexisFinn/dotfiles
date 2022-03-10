require('formatter').setup {
  filetype = {
    javascript = {
      function()
        return {
          exe = "prettier",
          args = {"--parser typescript", "-w"},
          stdin = true
        }
      end
    },
    typescript = {
      function()
        return {
          exe = "prettier",
          args = {"--parser vue", "-w"},
          stdin = true
        }
      end
    },
    vue = {
      function()
        return {
          exe = "prettier",
          args = {"--parser vue", "-w"},
          stdin = true
        }
      end
    },
    scss = {
      function()
        return {
          exe = "prettier",
          args = {"--parser scss", "-w"},
          stdin = true
        }
      end
    },
    css = {
      function()
        return {
          exe = "prettier",
          args = {"--parser css", "-w"},
          stdin = true
        }
      end
    },
    yaml = {
      function()
        return {
          exe = "prettier",
          args = {"--parser yaml", "-w"},
          stdin = true
        }
      end
    },
    html = {
      function()
        return {
          exe = "prettier",
          args = {"--parser html", "-w"},
          stdin = true
        }
      end
    },
    haskell = {
      function()
        return {
          exe = "hindent",
          stdin = true
        }
      end
    },
    python = {
      function()
        return {
          exe = "autopep",
          args = {"--ignore E501"},
          stdin = true
        }
      end
    },
    php = {
      function()
        return {
          exe = "php-cs-fixer",
          args = {"fix"},
          stdin = false
        }
      end
    },
    go = {
      function()
        return {
          exe = "goimports",
          args = {"-w"},
          stdin = true
        }
      end
    },
    rust = {
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
  }
}

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.lua,*.php,*.vue,*.go,*.ts,*.scss,*.css FormatWrite
augroup END
]], true)
