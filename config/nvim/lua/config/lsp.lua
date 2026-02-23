local lspConfig = vim.lsp.config

lspConfig("*", {root_markers = {".git"}})
lspConfig["biome"] = require("config/lsp/biome")
lspConfig["ts_ls"] = require("config/lsp/ts_ls")
lspConfig["lua-language-server"] = require("config/lsp/lua-language-server")
lspConfig["ts_ls"] = require("config/lsp/ts_ls")
lspConfig["awk"] = require("config/lsp/awk")
lspConfig["sonarlint"] = require("config/lsp/sonarlint")
lspConfig["zls"] = require("config/lsp/zls")
lspConfig["eslint"] = require("config/lsp/eslint")

-- enable desired lsp servers
vim.lsp.enable({
    "ts_ls", -- "biome", -- "sonarlint", 
    "lua-language-server", "awk", "zls"
})
if (vim.fs.root(vim.fn.getcwd(), ".git") ~= "/home/alexis/zest/ZestFront") then
    vim.lsp.enable({"biome"})
end

-- configure autocomplete behavior
vim.o.completeopt = "menu,noselect,popup,fuzzy"

-- configure lsp diagnostics behavior
vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = false, -- { current_line = true },
    underline = false,
    signs = true,
    update_in_insert = false
})

-- configure buffer/client specific lsp behavior
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local keymap = vim.keymap.set

        -- implement auto-completion manually
        -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- if client then
        --     -- trigger completion on each caracter if supported
        --     if client.server_capabilities and
        --         client.server_capabilities.completionProvider then
        --         client.server_capabilities.completionProvider.triggerCharacters =
        --             vim.split(
        --                 "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_. ",
        --                 "")
        --     end
        --     -- enable autocompletion for all lsp that support it
        --     if client and client:supports_method("textDocument/completion") then
        --         vim.lsp.completion.enable(true, client.id, ev.buf,
        --                                   {autotrigger = true})
        --     end
        --     -- inslay hints for all lsp that support it
        --     if client:supports_method("textDocument/inlayHint") then
        --         vim.lsp.inlay_hint.enable(true, {bufnr = ev.buf})
        --     end
        -- end

        -- disable lsp formatting on save, using "formatter" plugin instead
        vim.bo[ev.buf].formatexpr = nil

        -- Buffer local mappings.
        keymap("n", "gD", vim.lsp.buf.declaration,
               {buffer = ev.buf, desc = "LSP: Goto Declaration"})
        keymap("n", "gd", vim.lsp.buf.definition,
               {buffer = ev.buf, desc = "LSP: Goto Definition"})
    end
})
