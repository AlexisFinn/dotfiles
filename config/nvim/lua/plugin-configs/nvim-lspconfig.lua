-- auto format on save running whatever lsp is configured for current file
vim.api.nvim_command('autocmd BufWritePost * silent! lua vim.lsp.buf.formatting()')

-- auto show diagnostic messages in popup
-- vim.api.nvim_command('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
-- define signs
vim.api.nvim_command('sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignWarning text= texthl=LspDiagnosticsSignWarning linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=')
vim.api.nvim_command('sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=')

-- formatting configuration
require("lsp-format").setup {
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


-- base handler configuration, to override default settings
local handlerVirtualText = {
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
  -- add nvim-cmp (autocomplete) to lsp capabilities
  client.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- disable formating as that will be taken care of elsewhere
  -- client.resolved_capabilities.document_formatting = false
  require('lsp-format').on_attach(client)
  -- show doc with 'K'
  vim.api.nvim_set_keymap('n', 'K', ':lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  -- jump to definition
  vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.api.nvim_set_keymap("n", "tt", "<cmd>lua vim.diagnostic.open_float()<CR>", {noremap = true, silent = true})
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
  handlers = handlerVirtualText,
  on_attach = onAttachNoFormatting,
}

require('lspconfig').psalm.setup{
  handlers = handlerVirtualText,
  on_attach = onAttachNoFormatting,
}

-- require('lspconfig').phan.setup{
  -- handlers = handlerVirtualText,
  -- on_attach = onAttachNoFormatting,
-- }


-- python
require('lspconfig').pylsp.setup{
  handlers = handlerVirtualText,
  on_attach = onAttachNoFormatting,
}

-- vue
require('lspconfig').vuels.setup{
  handlers = handlerVirtualText,
  on_attach = onAttachNoFormatting,
}

-- typescript
require('lspconfig').tsserver.setup{
  handlers = handlerVirtualText,
  on_attach = onAttachNoFormatting,
}

-- yaml
require('lspconfig').yamlls.setup{
  handlers = handlerVirtualText,
  on_attach = onAttachNoFormatting,
}

-- stylelint
require('lspconfig').stylelint_lsp.setup{
  on_attach = onAttachNoFormatting,
  handlers = handlerVirtualText,
  filetypes = {"css", "scss", "vue"},
  settings = {
    stylelintplus = {
      autoFixOnFormat = false,
      autoFixOnSave = true,
      validateOnType = true,
    }
  }
}

-- golang
require('lspconfig').gopls.setup{
  on_attach = onAttachNoFormatting,
}

--rust
require('lspconfig').rls.setup{
  on_attach = onAttachNoFormatting,
}

-- lua
local sumneko_root_path = '/home/alexis/Applications/lua-language-server'
require('lspconfig').sumneko_lua.setup {
  handlers = handlerVirtualText,
  filetypes = {"lua"},
  cmd = {"lua-language-server", "-E", sumneko_root_path..'/main.lua'},
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
        library = vim.api.nvim_get_runtime_file("", true),
        -- library = {
          -- [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          -- [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        -- }
      },
      telementry = {
        enable = false,
      }
    }
  }
}

-- haskell
require('lspconfig').hls.setup{}

-- C++
require('lspconfig').ccls.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
    clang = {
      excludeArgs = {"-frounding-math"};
    }
  }
}

