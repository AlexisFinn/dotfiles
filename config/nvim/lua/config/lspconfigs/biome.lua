return {
  cmd = {
    vim.fn.expand("$MASON/bin/biome"),
    "lsp-proxy",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "biome.json", "biome.jsonc", "package.json", "tsconfig.json", "jsconfig.json" },
}
