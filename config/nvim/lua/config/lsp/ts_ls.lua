return {
  cmd = {
    vim.fn.expand("typescript-language-server"),
    "--stdio",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".eslintrc", ".tslintrc" },
}
