return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- disable lsp formatting on save
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args) vim.bo[args.buf].formatexpr = nil end,
      })

      -- global diagnostic settings
      vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        signs = true,
        update_in_insert = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local keymap = vim.keymap.set
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          local opts = { buffer = ev.buf }
          keymap("n", "gD", vim.lsp.buf.declaration, opts)
          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "gi", vim.lsp.buf.implementation, opts)
          keymap("n", "<space>D", vim.lsp.buf.type_definition, opts)
          keymap("n", "<space>rn", vim.lsp.buf.rename, opts)
          keymap({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "gr", vim.lsp.buf.references, opts)
          keymap("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opts)
        end,
      })

      -- html
      require("lspconfig").html.setup({
        cmd = { "html-languageserver", "--stdio" },
        filetype = { "html" },
      })
      -- docker
      require("lspconfig").dockerls.setup({})
      -- python
      require("lspconfig").pylsp.setup({})
      -- ts & js
      require("lspconfig").ts_ls.setup({
        settings = {
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })
      require("lspconfig").biome.setup({})
      -- stylelint
      require("lspconfig").stylelint_lsp.setup({
        filetypes = { "css", "scss", "vue", "html" },
        settings = {
          stylelintplus = {
            autoFixOnFormat = false,
            autoFixOnSave = true,
            validateOnType = true,
          },
        },
      })
      -- lua
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      -- zig
      require("lspconfig").zls.setup({})
    end,
  },
  { -- SONAR QUBE
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    enabled = false,
    config = function()
      require("sonarlint").setup({
        server = {
          cmd = {
            vim.fn.expand("$MASON/bin/sonarlint-language-server"),
            "-stdio",
            "-analyzers",
            -- paths to the analyzers you need, using those for python and java in this example
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
          },
        },
        filetypes = {
          "javascript",
          "typescript",
        },
      })
    end,
  },
}
