return {
  cmd = {
    vim.fn.expand("biome"),
    "lsp-proxy",
  },
  filetypes = {
    "json",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "biome.json", "biome.jsonc", "package.json", "tsconfig.json", "jsconfig.json" },
}
