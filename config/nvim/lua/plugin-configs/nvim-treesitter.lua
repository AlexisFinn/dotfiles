return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  branch = "master",
  dependencies = {
    'nvim-treesitter/playground',
  },
  opts = {
      ensure_installed = {
        "gitcommit",
        "gitignore",
        "git_rebase",
        "git_config",
        "bash",
        "dockerfile",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "php",
        "phpdoc",
        "go",
        "godot_resource",
        "gomod",
        "gosum",
        "gowork",
        "python",
        "regex",
        "sql",
        "tsx",
        "twig",
        "yaml",
        "xml",
        "javascript",
        "typescript",
        "html",
        "vue",
        "css",
        "scss"
      }, --"all",
      context_commentstring = {
        enable = true
      },
      highlight = {
        enable = false,
        additional_vim_regex_highlighting = false
      },
      rainbow = {
        enable = true
      }
  }
}

