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
  'nvim-tree/nvim-web-devicons',
  'ryanoasis/vim-devicons',
  -- smooth scrolling
  'psliwka/vim-smoothie',
  -- animated indent guides
  require("plugin-configs.mini-indentscope"),
  -- status line in lua
  'hoob3rt/lualine.nvim',
  -- tab line
  require("plugin-configs.barbar"),
  -- color highlighter
  require("plugin-configs.nvim-colorizer"),
  -- shortcuts helper including registers, marks, keymaps, folds...
  require("plugin-configs.which-key"),
  -- highlight matching words
  require("plugin-configs.vim-illuminate"),
  -- treesitter the new language parser
  require("plugin-configs.nvim-treesitter"),
  -- semantic highlighting using treesitter
  require("plugin-configs.hlargs"),
  -- vim UI for messages, cmdline and popupmenu
  require('plugin-configs.noice'),
  -- indent guides
  'lukas-reineke/indent-blankline.nvim',
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
  -- utilsnips
  {
    'fhill2/telescope-ultisnips.nvim',
    dependencies = 'SirVer/ultisnips'
  },
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
  {
    'vijaymarupudi/nvim-fzf', -- lua api
    dependencies = 'vijaymarupudi/nvim-fzf-commands', -- actual vim commands
  },
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  require("plugin-configs.telescope"),
  -- ripgrep for fastest ever grep directly in vim
  'jremmen/vim-ripgrep',
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
  'nelsyeung/twig.vim',
  -- haskell
  'neovimhaskell/haskell-vim',
  -- rust
  'simrat39/rust-tools.nvim',
  -- .editorconfig file if found
  'editorconfig/editorconfig-vim',
  -- auto change matching html tags
  'AndrewRadev/tagalong.vim',
  ------------------------
  -- FUNCTIONAL PLUGINS --
  ------------------------
  -- buffer switcher
  require("plugin-configs.JABS"),
  -- Comment/uncomment multiple lines with <leader>c<space>
  require("plugin-configs.nvim-comment"),
  -- easyMotion clone for Nvim
  require("plugin-configs.leap"),
  -- Run terminal commands in floating windows
  'voldikss/vim-floaterm',
  -- doc comment generator
  require("plugin-configs.neogen"),
  -- auto session management per cwd
  require("plugin-configs.auto-session"),
  -- convert to multiline
  'AndrewRadev/splitjoin.vim',
  -- bookmarks
  'MattesGroeger/vim-bookmarks',
  ---------
  -- GIT --
  ---------
  -- best git commands integration for vim
  'tpope/vim-fugitive',
  -- git diff indications in gutter column
  require("plugin-configs.gitsigns"),
  -----------
  -- OTHER --
  -----------
  -- an aswesome helper for writting custom colorschemes for Nvim
  require("plugin-configs.colorbuddy"),
  -- games
  'ThePrimeagen/vim-be-good', -- type :VimBeGood
})
