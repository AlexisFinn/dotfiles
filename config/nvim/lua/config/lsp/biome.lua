return {
    cmd = {vim.fn.expand("biome"), "lsp-proxy"},
    filetypes = {
        "json", "javascript", "javascriptreact", "typescript", "typescriptreact"
    },
    capabilities = {offset_encoding = {"utf-16"}},
    root_markers = {
        "biome.json", "biome.jsonc", "package.json", "tsconfig.json",
        "jsconfig.json"
    }
}
