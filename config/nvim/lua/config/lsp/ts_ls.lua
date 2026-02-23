return {
    cmd = {vim.fn.expand("typescript-language-server"), "--stdio"},
    filetypes = {
        "javascript", "javascriptreact", "typescript", "typescriptreact"
    },
    root_markers = {
        "tsconfig.json", "jsconfig.json", "package.json", ".eslintrc",
        ".tslintrc"
    },
    init_options = {
        preferences = {
            -- Disable features that slow down initial load
            disableSuggestions = false,
            includeCompletionsForModuleExports = true,
        },
        -- Skip full project load for faster startup
        maxTsServerMemory = 4096,
    },
    settings = {
        typescript = {
            inlayHints = {
                -- Disable inlay hints initially (they require full type resolution)
                includeInlayParameterNameHints = "none",
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
            },
        },
    },
}
