local lspConfig = vim.lsp.config

lspConfig("*", {root_markers = {".git"}})
lspConfig["biome"] = require("config/lsp/biome")
-- lspConfig["copilot"] = require("config/lsp/copilot")
lspConfig["ts_ls"] = require("config/lsp/ts_ls")
lspConfig["lua-language-server"] = require("config/lsp/lua-language-server")
lspConfig["ts_ls"] = require("config/lsp/ts_ls")
lspConfig["awk"] = require("config/lsp/awk")
lspConfig["sonarlint"] = require("config/lsp/sonarlint")
lspConfig["zls"] = require("config/lsp/zls")
lspConfig["eslint"] = require("config/lsp/eslint")
lspConfig["r"] = require("config/lsp/r-language-server")

-- enable desired lsp servers
vim.lsp.enable({
    "ts_ls", -- "copilot", -- "biome", -- "sonarlint", 
    "lua-language-server", "awk", "zls", "r"
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
    callback = function(args)
        local keymap = vim.keymap.set
        -- local bufnr = args.buf
        -- local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- if client:supports_method(vim.lsp.protocol.Methods
        --                               .textDocument_inlineCompletion, bufnr) then
        --     vim.lsp.inline_completion.enable(true, {bufnr = bufnr})
        --     --
        --     vim.keymap.set('i', '<C-y>', vim.lsp.inline_completion.get, {
        --         desc = 'LSP: accept inline completion',
        --         buffer = bufnr
        --     })
        --     vim.keymap.set('i', '<C-n>', vim.lsp.inline_completion.select, {
        --         desc = 'LSP: switch inline completion',
        --         buffer = bufnr
        --     })
        -- end

        -- disable lsp formatting on save, using "formatter" plugin instead
        vim.bo[args.buf].formatexpr = nil

        -- Buffer local mappings.
        keymap("n", "gD", vim.lsp.buf.declaration,
               {buffer = args.buf, desc = "LSP: Goto Declaration"})
        keymap("n", "gd", vim.lsp.buf.definition,
               {buffer = args.buf, desc = "LSP: Goto Definition"})
    end
})
