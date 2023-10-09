local lazyOptions = {
  ui = {
    border = "rounded",
  },
  performance = {
    cache = {enabled = true},
    rtp = {
      disabled_plugins = {
        "netrwPlugin",
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin"
      }
    }
  },
  debug = false,
}

require("lazy").setup({
  -------------------
  -- COLOR SCHEMES --
  -------------------
  -- colorschemes, load them first for proper integration with other plugins
  require("plugin-configs.colorschemes"),
  ---------------
  -- EYE CANDY --
  ---------------
  -- some nice icons
  require("plugin-configs.nvim-web-devicons"),
  -- smooth scrolling
  require("plugin-configs.vim-smoothie"),
  -- animated indent guides
  -- require("plugin-configs.mini-indentscope"),
  -- status line in lua
  require("plugin-configs.lualine"),
  -- tab line
  -- require("plugin-configs.barbar"),
  -- color highlighter
  require("plugin-configs.nvim-colorizer"),
  -- shortcuts helper including registers, marks, keymaps, folds...
  require("plugin-configs.which-key"),
  -- highlight matching words
  -- require("plugin-configs.vim-illuminate"),
  require("plugin-configs.strcursorword"),
  -- treesitter the new language parser
  require("plugin-configs.nvim-treesitter"),
  -- semantic highlighting using treesitter
  require("plugin-configs.hlargs"),
  -- vim UI for messages, cmdline and popupmenu
  require('plugin-configs.noice'),
  -- indent guides
  require('plugin-configs.indent-blankline'),
  ---------------
  -- LSP SETUP --
  ---------------
  -- Install LSP dependencies with Mason
  require("plugin-configs.mason-lspconfig"),
  -- auto lua lsp configuration. !! MUST COME BEFORE LSP-CONFIG
  require("plugin-configs.neodev"),
  -- Language Server Protocol integration (this is so cool)
  require("plugin-configs.nvim-lspconfig"),
  -- better defaults for builtin lsp
  require("plugin-configs.nvim-lsputils"),
  -- show function signature as you type
  require('plugin-configs.lsp-signature'),
  -- auto-formatting
  require('plugin-configs.formatter'),
  -- access language REPL
  require("plugin-configs.iron"),
  -- code snippets
  require("plugin-configs.utilsnips"),
  -- better diagnostics
  require("plugin-configs.trouble"),
  -- autocomplete
  require("plugin-configs.nvim-cmp"),
  -- debugging protocol
  require("plugin-configs.nvim-dap-virtual-text"),
  ----------------------------
  -- TELESCOPE FUZZY FINDER --
  ----------------------------
  -- fzf because it's the best fuzzy finder
  require('plugin-configs.nvim-fzf'),
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  require("plugin-configs.nvim-telescope"),
  -- ripgrep for fastest ever grep directly in vim
  require("plugin-configs.vim-ripgrep"),
  -------------------------------
  -- LANGUAGE SPECIFIC PLUGINS --
  -------------------------------
  -- GoLang
  require("plugin-configs.go"),
  -- markdown preview
  require("plugin-configs.markdown-preview"),
  -- emmet
  require("plugin-configs.emmet"),
  -- twig
  require("plugin-configs.twig"),
  -- haskell
  -- require("plugin-configs.haskell-vim"),
  -- rust
  -- require("plugin-configs.rust-tools"),
  -- .editorconfig file if found
  require("plugin-configs.editorconfig-vim"),
  -- auto change matching html tags
  require("plugin-configs.tagalong"),
  -- Varnish Conif Language (VCL)
  require("plugin-configs.vim-varnish"),
  -- CSV
  require("plugin-configs.rainbow-csv"),
  
  --------
  -- AI --
  --------
  -- Codmium
  require("plugin-configs.codeium"),
  ------------------------
  -- FUNCTIONAL PLUGINS --
  ------------------------
  -- buffer switcher
  -- require("plugin-configs.JABS"),
  -- Comment/uncomment multiple lines with <leader>c<space>
  -- require("plugin-configs.nvim-comment"),
  require("plugin-configs.mini-comment"),
  -- easyMotion clone for Nvim
  require("plugin-configs.leap"),
  -- Run terminal commands in floating windows
  require("plugin-configs.vim-floaterm"),
  -- doc comment generator
  require("plugin-configs.neogen"),
  -- auto session management per cwd
  require("plugin-configs.auto-session"),
  -- convert to multiline
  require("plugin-configs.splitjoin"),
  -- bookmarks
  require("plugin-configs.vim-bookmarks"),
  ---------
  -- GIT --
  ---------
  -- best git commands integration for vim
  -- require("plugin-configs.vim-fugitive"),
  -- git blame integration
  require("plugin-configs.blame"),
  -- git diff indications in gutter column
  require("plugin-configs.gitsigns"),
  -----------
  -- OTHER --
  -----------
  -- an aswesome helper for writting custom colorschemes for Nvim
  require("plugin-configs.colorbuddy"),
  -- games ( type :VimBeGood )
  require("plugin-configs.vim-be-good"),
}, lazyOptions)
