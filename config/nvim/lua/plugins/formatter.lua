return {
  "mhartington/formatter.nvim",
  config = function()
    require("formatter").setup({
      filetype = {
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        zig = {
          function()
            return {
              exe = "zig",
              args = { "fmt", "--stdin" },
              stdin = true,
            }
          end,
        },
        json = {
          function()
            return {
              exe = "fixjson",
              args = { "-w", "--stdin-filename" },
              stdin = true,
            }
          end,
        },
        javascript = {
          function()
            -- if project contains a .prettierrc file, use it
            if vim.fn.filereadable(".prettierrc.js") == 1 or vim.fn.filereadable(".prettierrc") == 1 then
              return {
                exe = "prettier",
                args = { "--parser typescript", "-w" },
                stdin = true,
              }
            else
              return {
                exe = "prettier",
                args = { "--parser babel", "--config /home/alexis/.prettierrc", "-w" },
                stdin = true,
              }
            end
          end,
        },
        typescript = {
          function()
            return {
              exe = "prettier",
              args = { "--parser typescript", "-w" },
              stdin = true,
            }
          end,
        },
        vue = {
          function()
            return {
              exe = "prettier",
              args = { "--parser vue", "-w" },
              stdin = true,
            }
          end,
        },
        scss = {
          function()
            return {
              exe = "prettier",
              args = { "--parser scss", "-w" },
              stdin = true,
            }
          end,
        },
        css = {
          function()
            return {
              exe = "prettier",
              args = { "--parser css", "-w" },
              stdin = true,
            }
          end,
        },
        sql = {
          function()
            return {
              exe = "sql-formatter",
              args = { "-l postgresql" },
              stdin = true,
            }
          end,
        },
        typescriptreact = {
          function()
            return {
              exe = "prettier",
              args = { "--parser typescript", "-w" },
              stdin = true,
            }
          end,
        },
        yaml = {
          function()
            return {
              exe = "prettier",
              args = { "--parser yaml", "-w" },
              stdin = true,
            }
          end,
        },
        html = {
          function()
            return {
              exe = "prettier",
              args = { "--parser html", "-w" },
              stdin = true,
            }
          end,
        },
        haskell = {
          function()
            return {
              exe = "hindent",
              stdin = true,
            }
          end,
        },
        python = {
          function()
            return {
              exe = "autopep",
              args = { "--ignore E501" },
              stdin = true,
            }
          end,
        },
        php = {
          function()
            return {
              exe = vim.fn.getcwd() .. "/phpCsFixer.sh",
              args = {},
              -- exe = "php-cs-fixer",
              -- args = { "fix" },
              stdin = false,
            }
          end,
        },
        go = {
          function()
            return {
              exe = "goimports-reviser",
              args = { "-format" },
            }
          end,
          function()
            return {
              exe = "gofumpt",
              args = { "-w" },
            }
          end,
          function()
            return {
              exe = "golines",
              args = { "-w" },
            }
          end,
        },
        rust = {
          function()
            return {
              exe = "rustfmt",
              args = { "--emit=stdout" },
              stdin = true,
            }
          end,
        },
      },
    })

    -- auto-format on save
    vim.api.nvim_exec2(
      [[
    augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.js,*.mjs,*.rs,*.lua,*.php,*.vue,*.go,*.ts,*.scss,*.css,*.html,*.tsx,*.sql,*.zig,*.json FormatWrite
    augroup END
    ]],
      { output = true }
    )
  end,
}
