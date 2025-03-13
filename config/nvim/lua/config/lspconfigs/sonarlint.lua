return {
  cmd = {
    vim.fn.expand("$MASON/bin/sonarlint-language-server"),
    "-stdio",
    "-analyzers",
    -- paths to the analyzers you need, using those for python and java in this example
    vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
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
