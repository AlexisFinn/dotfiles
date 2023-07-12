-- auto format on save running whatever lsp is configured for current file
--vim.api.nvim_command('autocmd BufWritePost * silent! lua vim.lsp.buf.format()')
-- vim.api.nvim_command('autocmd BufWritePost * silent! lua vim.lsp.buf.formatting()')
-- auto show diagnostic messages in popup
-- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
-- define signs
vim.api.nvim_command('sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=')

local util = require('lspconfig').util

-- base handler configuration, to override default settings
local handlerVirtualText = {
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    underline = true,
    signs = true,
    update_in_insert = true,
  })
}


-- onAttach callback to disable formatting and setting keymaps
local onAttach = (function(client, bufnr)

  -- add custom formatting
  -- require('lsp-format').on_attach(client)

  -- disable formating as that will be taken care of elsewhere
  -- nvim <= 0.7
  -- client.resolved_capabilities.document_formatting = false
  -- nvim 0.8+
  client.server_capabilities.documentFormattingProvider = false
  -- if client.name == "vuels" then
  --   client.server_capabilities.semanticTokensProvider = nil
  -- end

  -- add nvim-cmp (autocomplete) to lsp capabilities
  client.capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- show doc with 'K'
  vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
  -- jump to definition
  vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "tt", "<cmd>lua vim.diagnostic.open_float()<CR>",
  -- { noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "tn", function ()
    -- vim.diagnostic.goto_next({border="rounded"})
  -- end,{ noremap = true, silent = true })
  -- vim.api.nvim_set_keymap("n", "tN", function()
    -- vim.diagnostic.goto_prev({border="rounded"})
  -- end,{ noremap = true, silent = true })
  -- vim.keymap.set("n", "tt", function()
    -- vim.diagnostic.open_float({border = "rounded"})
  -- end, { silent = true })
end)

-- html
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig').html.setup {
  cmd = { "html-languageserver", "--stdio" },
  on_attach = onAttach,
  --  capabilities = capabilities, -- does not provide completion if there are no snippets
  filetype = { "html" },
}

--docker
require('lspconfig').dockerls.setup {}

-- php
require('lspconfig').intelephense.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
  root_dir = util.root_pattern("vendor")
}

-- require('lspconfig').psalm.setup{
-- handlers = handlerVirtualText,
-- on_attach = onAttach,
-- root_dir = util.root_pattern("vendor")
-- }

require('lspconfig').phpactor.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
  root_dir = util.root_pattern("vendor")
}

-- require('lspconfig').phan.setup{
-- handlers = handlerVirtualText,
-- on_attach = onAttachNoFormatting,
-- }


-- python
require('lspconfig').pylsp.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
}

-- vue
require('lspconfig').vuels.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
}

-- vue 3
-- require('lspconfig').volar.setup {
--   handlers = handlerVirtualText,
--   on_attach = onAttach,
-- }

-- typescript
require('lspconfig').eslint.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
  filetypes = { "javascript", "typescript"}
}

require('lspconfig').tsserver.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
}

-- yaml
require('lspconfig').yamlls.setup {
  handlers = handlerVirtualText,
  on_attach = onAttach,
}

-- stylelint
require('lspconfig').stylelint_lsp.setup {
  on_attach = onAttach,
  handlers = handlerVirtualText,
  filetypes = { "css", "scss", "vue", "html" },
  settings = {
    stylelintplus = {
      autoFixOnFormat = false,
      autoFixOnSave = true,
      validateOnType = true,
    }
  }
}

-- golang
require('lspconfig').gopls.setup {
  on_attach = onAttach,
  capabilities = capabilities,
  handlers = handlerVirtualText,
  cmd = {"gopls"},
  filetypes = {"go", "gomod", "gowork", "gotmpl"},
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true
      }
    }
  }
}

--rust
-- require('lspconfig').rls.setup {
-- on_attach = onAttach,
-- }
require('rust-tools').setup {
  tools = {
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    on_attach = onAttach,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        }
      }
    }
  }
}

-- lua
require('lspconfig').lua_ls.setup {
  settings = {
    lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
}

-- haskell
require('lspconfig').hls.setup {}

-- C++
-- require('lspconfig').ccls.setup {
-- init_options = {
-- compilationDatabaseDirectory = "build";
-- index = {
-- threads = 0;
-- };
-- clang = {
-- excludeArgs = { "-frounding-math" };
-- }
-- }
-- }

-- formatting
-- require('lspconfig').efm.setup {
-- init_options = {documentFormatting = true},
-- filetypes = {'javascript', 'typescript', 'vue', 'scss', 'css', 'yaml', 'html', 'haskell', 'python', 'go', 'rust'},
-- settings = {
-- languages = formattingConfig
-- }
-- }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
  ---             - border = "none", "single", "double", "rounded", "solid", "shadow" | ["╔", "═" ,"╗", "║", "╝", "═", "╚", "║" ]
  ---             - height: (number) height of floating window
  ---             - width: (number) width of floating window
  ---             - wrap: (boolean, default true) wrap long lines
  ---             - wrap_at: (number) character to wrap at for computing height when wrap is enabled
  ---             - max_width: (number) maximal width of floating window
  ---             - max_height: (number) maximal height of floating window
  ---             - pad_top: (number) number of lines to pad contents at top
  ---             - pad_bottom: (number) number of lines to pad contents at bottom
  ---             - focus_id: (string) if a popup with this id is opened, then focus it
  ---             - close_events: (table) list of events that closes the floating window
  ---             - focusable: (boolean, default true) Make float focusable
  ---             - focus: (boolean, default true) If `true`, and if {focusable}
  ---                      is also `true`, focus an existing floating window with the same
  ---                      {focus_id}
  ---             - anchor: "NW", "NE", "SW", "SE"
  ---             - relative: "editor", "win", "cursor"
  border = "rounded",
  -- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
}
)
