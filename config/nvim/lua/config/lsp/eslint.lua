return {
    cmd = {vim.fn.expand("eslint_d"), "--stdin"},
    filetypes = {
        "json", "javascript", "javascriptreact", "typescript", "typescriptreact"
    },
    capabilities = {offset_encoding = {"utf-16"}},
    root_markers = {"webpack.config.js", ".eslintrc", "package.json"}
}
