local lspConfig = vim.lsp.config

lspConfig("*", {
  root_markers = { ".git" },
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  signs = true,
  update_in_insert = true,
  float = {
    border = "rounded",
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local keymap = vim.keymap.set

    -- disable lsp formatting on save, using "formatter" plugin instead
    vim.bo[args.buf].formatexpr = nil

    -- Buffer local mappings.
    local opts = { buffer = args.buf }
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

lspConfig["ts_ls"] = require("config.lspconfigs.ts_ls")
vim.lsp.enable("ts_ls")

lspConfig["biome"] = require("config.lspconfigs.biome")
vim.lsp.enable("biome")

lspConfig["sonarlint"] = require("config.lspconfigs.sonarlint")
