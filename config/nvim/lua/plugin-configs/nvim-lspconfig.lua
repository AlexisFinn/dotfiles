-- auto format on save running whatever lsp is configured for current file
vim.api.nvim_command('autocmd BufWritePost * silent! lua vim.lsp.buf.formatting()')

-- auto show diagnostic messages in popup
-- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
-- define signs
--vim.api.nvim_command('sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=')
--vim.api.nvim_command('sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=')
--vim.api.nvim_command('sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=')
--vim.api.nvim_command('sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=')


-- base handler configuration, to override default settings
local handlerNoVirtualText = {
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      underline = true,
      signs = true,
      update_in_insert = false,
    }
  )
}

-- onAttach callback to disable formatting and setting keymaps
local onAttachNoFormatting = (function(client)
  -- disable formating as that will be taken care of elsewhere
  client.resolved_capabilities.document_formatting = false
  -- show doc with 'K'
  vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  -- jump to definition
  vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "tt", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", {noremap = true, silent = true})
end)

-- html
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

require('lspconfig').html.setup{
  cmd = {"html-languageserver", "--stdio"},
  on_attach = onAttachNoFormatting,
--  capabilities = capabilities, -- does not provide completion if there are no snippets
  filetype = {"html"},
}

--docker
require('lspconfig').dockerls.setup {}

-- php
require('lspconfig').intelephense.setup{
  handlers = handlerNoVirtualText,
  on_attach = onAttachNoFormatting,
}

-- vue
require('lspconfig').vuels.setup{
  handlers = handlerNoVirtualText,
  on_attach = onAttachNoFormatting,
}

-- typescript
require('lspconfig').tsserver.setup{
  handlers = handlerNoVirtualText,
  on_attach = onAttachNoFormatting,
}

-- yaml
require('lspconfig').yamlls.setup{
  handlers = handlerNoVirtualText,
  on_attach = onAttachNoFormatting,
}

-- stylelint
require('lspconfig').stylelint_lsp.setup{
  on_attach = onAttachNoFormatting,
  handlers = handlerNoVirtualText,
  filetypes = {"css", "scss", "vue"},
  settings = {
    stylelintplus = {
      autoFixOnFormat = false,
      autoFixOnSave = true,
      validateOnType = true,
    }
  }
}

-- lua
local sumneko_root_path = '/home/alexis/Applications/lua-language-server'
local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
require('lspconfig').sumneko_lua.setup {
  handlers = handlerNoVirtualText,
  filetypes = {"lua"},
  cmd = {sumneko_binary, "-E", sumneko_root_path..'/main.lua'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        }
      },
      telementry = {
        enable = false,
      }
    }
  }
}

-- haskell
require('lspconfig').hls.setup{}

-- efm is a general purpose lsp, I use it to centralise and cutomise the auto-formatting tools for each language
require('lspconfig').efm.setup {
  filetypes = {"typescript", "vue", "scss", "css", "html", "yaml", "php", "javascript", "haskell"},
  init_options = {documentFormatting = true},
  settings = {
    rootMarkers = {".git/"},
    languages = {
      typescript = {
        {formatCommand = "prettier --parser typescript", formatStdin = true}
      },
      vue = {
        {formatCommand = "prettier --parser vue", formatStdin = true}
      },
      scss = {
        {formatCommand = "prettier --parser scss", formatStdin = true}
      },
      css = {
        {formatCommand = "prettier --parser css", formatStdin = true}
      },
      html = {
        {formatCommand = "prettier --parser html", formatStdin = true}
      },
      yaml = {
        {formatCommand = "prettier --parser yaml", formatStdin = true}
      },
      javascript = {
        {formatCommand = "prettier --parser typescript", formatStdin = true}
      },
      haskell = {
        {formatCommand = "hindent", formatStdin = true}
      }
    }
  }
}
