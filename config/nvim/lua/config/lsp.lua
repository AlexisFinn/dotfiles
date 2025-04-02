local lspConfig = vim.lsp.config

lspConfig("*", {
  root_markers = { ".git" },
})

lspConfig["ts_ls"] = require("config.lspconfigs.ts_ls")
vim.lsp.enable("ts_ls")

lspConfig["biome"] = require("config.lspconfigs.biome")
vim.lsp.enable("biome")

lspConfig["sonarlint"] = require("config.lspconfigs.sonarlint")
-- vim.lsp.enable("sonarlint")

lspConfig["awk"] = require("config.lspconfigs.awk")
vim.lsp.enable("awk")

-- configure autocomplete behavior
vim.o.completeopt = "menu,noselect,popup,fuzzy"

-- configure lsp diagnostics behavior
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false, -- { current_line = true },
  underline = true,
  signs = true,
  update_in_insert = true,
  float = {
    border = "rounded",
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local keymap = vim.keymap.set
    -- enable autocompletion for the client
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- disable lsp formatting on save, using "formatter" plugin instead
    vim.bo[args.buf].formatexpr = nil

    -- Buffer local mappings.
    local opts = { buffer = args.buf }
    keymap("n", "gD", vim.lsp.buf.declaration, { buffer = args.buf, desc = "LSP: Goto Declaration" })
    keymap("n", "gd", vim.lsp.buf.definition, { buffer = args.buf, desc = "LSP: Goto Definition" })
  end,
})
