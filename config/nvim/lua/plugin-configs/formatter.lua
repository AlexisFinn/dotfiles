return  {
  'mhartington/formatter.nvim',
  config = function()
    require('formatter').setup {
      filetype = {
        json = {
          function()
            return {
              exe = "prettier",
              args = { "--parser json", "-w" },
              stdin = true
            }
          end
        },
        javascript = {
          function()
            return {
              exe = "prettier",
              args = { "--parser typescript", "-w" },
              stdin = true
            }
          end
        },
        typescript = {
          function()
            return {
              exe = "prettier",
              args = { "--parser typescript", "-w" },
              stdin = true
            }
          end
        },
        vue = {
          function()
            return {
              exe = "prettier",
              args = { "--parser vue", "-w" },
              stdin = true
            }
          end
        },
        scss = {
          function()
            return {
              exe = "prettier",
              args = { "--parser scss", "-w" },
              stdin = true
            }
          end
        },
        css = {
          function()
            return {
              exe = "prettier",
              args = { "--parser css", "-w" },
              stdin = true
            }
          end
        },
        typescriptreact = {
          function ()
            return {
              exe = "prettier",
              args = { "--parser typescript", "-w"},
              stdin = true
            }
          end
        },
        yaml = {
          function()
            return {
              exe = "prettier",
              args = { "--parser yaml", "-w" },
              stdin = true
            }
          end
        },
        html = {
          function()
            return {
              exe = "prettier",
              args = { "--parser html", "-w" },
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
              args = { "--ignore E501" },
              stdin = true
            }
          end
        },
        php = {
          function()
            return {
              exe = vim.fn.getcwd() .. "/phpCsFixer.sh",
              args = {},
              -- exe = "php-cs-fixer",
              -- args = { "fix" },
              stdin = false
            }
          end
        },
        go = {
          function()
            return {
              exe = "goimports-reviser",
              args = { "-rm-unused", "-format", "-set-alias"},
            }
          end,
          function ()
            return {
              exe = "gofumpt",
              args = {"-w"},
            }
          end,
          function ()
            return {
              exe = "golines",
              args = {"-w"}
            }
          end
        },
        rust = {
          function()
            return {
              exe = "rustfmt",
              args = { "--emit=stdout" },
              stdin = true
            }
          end
        },
      }
    }
    -- auto-format on save
    vim.api.nvim_exec([[
    augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.json,*.js,*.rs,*.lua,*.php,*.vue,*.go,*.ts,*.scss,*.css,*.html,*.tsx FormatWrite
    augroup END
    ]], true)
  end
}
