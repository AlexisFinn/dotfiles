return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function() require("mason").setup() end,
    },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "html",
      "dockerls",
      "pylsp",
      "eslint",
      "ts_ls",
      "yamlls",
      "stylelint_lsp",
      "lua_ls",
      -- 'vuels',
      -- 'gopls',
      -- 'intelephense',
      -- 'phpactor@2022.11.12',
    },
  },
}
