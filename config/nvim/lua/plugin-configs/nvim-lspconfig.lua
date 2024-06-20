return {
  "neovim/nvim-lspconfig",
  config = function()
    local util = require("lspconfig").util

    -- local lsp_defaults = util.default_config
    -- lsp_defaults.capabilities = vim.tbl_deep_extend(
    --   'force',
    --   lsp_defaults.capabilities,
    --   require('cmp_nvim_lsp').default_capabilities()
    -- )

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
        keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        -- keymap('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- keymap('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- keymap('n', '<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)
        keymap("n", "<space>D", vim.lsp.buf.type_definition, opts)
        keymap("n", "<space>rn", vim.lsp.buf.rename, opts)
        keymap({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opts)
      end,
    })

    -- onAttach callback to disable formatting and setting keymaps
    local onAttach = function(client, _) client.server_capabilities.documentFormattingProvider = false end

    -- base handler configuration, to override default settings
    local handlerVirtualText = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        underline = true,
        signs = true,
        update_in_insert = true,
      }),
      ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      }),
    }

    require("lspconfig").html.setup({
      cmd = { "html-languageserver", "--stdio" },
      on_attach = onAttach,
      filetype = { "html" },
    })

    -- require("lspconfig").emmet_language_server.setup({
    --   filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
    -- })

    --docker
    require("lspconfig").dockerls.setup({})
    -- php
    -- require("lspconfig").intelephense.setup({
    --   handlers = handlerVirtualText,
    --   on_attach = onAttach,
    --   root_dir = util.root_pattern("vendor"),
    -- })

    -- require('lspconfig').phpactor.setup {
    --   handlers = handlerVirtualText,
    --   on_attach = onAttach,
    --   root_dir = util.root_pattern("vendor")
    -- }

    -- gleam
    require("lspconfig").gleam.setup({})

    -- python
    require("lspconfig").pylsp.setup({
      handlers = handlerVirtualText,
      on_attach = onAttach,
    })

    -- vue
    -- require("lspconfig").vuels.setup({
    --   handlers = handlerVirtualText,
    --   on_attach = onAttach,
    -- })

    -- typescript & javascript
    require("lspconfig").eslint.setup({
      handlers = handlerVirtualText,
      on_attach = onAttach,
      filetypes = { "javascript", "typescript" },
      settings = {
        useFlatConfig = false,
        experimental = {
          useFlatConfig = nil,
        },
      },
    })
    require("lspconfig").tsserver.setup({
      handlers = handlerVirtualText,
      on_attach = onAttach,
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

    -- yaml
    require("lspconfig").yamlls.setup({
      handlers = handlerVirtualText,
      on_attach = onAttach,
    })

    -- stylelint
    require("lspconfig").stylelint_lsp.setup({
      on_attach = onAttach,
      handlers = handlerVirtualText,
      filetypes = { "css", "scss", "vue", "html" },
      settings = {
        stylelintplus = {
          autoFixOnFormat = false,
          autoFixOnSave = true,
          validateOnType = true,
        },
      },
    })

    -- golang
    -- require("lspconfig").gopls.setup({
    --   on_attach = onAttach,
    --   capabilities = capabilities,
    --   handlers = handlerVirtualText,
    --   cmd = { "gopls" },
    --   filetypes = { "go", "gomod", "gowork", "gotmpl" },
    --   root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    --   settings = {
    --     gopls = {
    --       completeUnimported = true,
    --       usePlaceholders = true,
    --       analyses = {
    --         unusedparams = true,
    --       },
    --     },
    --   },
    -- })

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
    require("lspconfig").zls.setup({
      handlers = handlerVirtualText,
      on_attach = onAttach,
    })
  end,
}
