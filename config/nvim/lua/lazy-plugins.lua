require("lazy").setup({
  -- colorschemes, load them first for proper integration with other plugins
  'mhartington/oceanic-next',
  'dracula/vim',
  'haishanh/night-owl.vim',
  'Shadorain/shadotheme',
  'bluz71/vim-moonfly-colors',
  'rafamadriz/neon',
  'marko-cerovac/material.nvim',
  'sainnhe/gruvbox-material',
  'sainnhe/sonokai',
  'romgrk/doom-one.vim',
  'wadackel/vim-dogrun',
  'arcticicestudio/nord-vim',
  'jnurmine/Zenburn',
  'gosukiwi/vim-atom-dark',
  'NLKNguyen/papercolor-theme',
  'jacoborus/tender.vim',
  'rakr/vim-one',
  'drewtempelmeyer/palenight.vim',
  'folke/tokyonight.nvim',
  'whatyouhide/vim-gotham',
  'rebelot/kanagawa.nvim',
  'cocopon/iceberg.vim',
  'pineapplegiant/spaceduck',
  'sainnhe/everforest',
  'junegunn/seoul256.vim',
  'EdenEast/nightfox.nvim',
  'ayu-theme/ayu-vim',
  'savq/melange',
  { 'catppuccin/nvim', name = 'catppuccin' },
  'kvrohit/mellow.nvim',
  -- some nice icons
  'nvim-tree/nvim-web-devicons',
  'ryanoasis/vim-devicons',
  -- smooth scrolling
  'psliwka/vim-smoothie',
  ---------------
  -- LSP SETUP --
  ---------------
  -- auto lua lsp configuration. !! MUST COME BEFORE LSP-CONFIG
  {
    'folke/neodev.nvim',
    config = function()
      require("plugin-configs.neodev")
    end
  },
  -- Language Server Protocol integration (this is so cool)
  {
    'neovim/nvim-lspconfig',
    config = function()
      require("plugin-configs.nvim-lspconfig")
    end
  },
  -- better defaults for builtin lsp
  {
    'RishabhRD/nvim-lsputils',
    dependencies = { 'RishabhRD/popfix' },
    config = function()
      require("plugin-configs.nvim-lsputils")
    end
  },
  -- show function signature as you type
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('plugin-configs.lsp-signature')
    end
  },
  -- auto-formatting
  {
    'mhartington/formatter.nvim',
    config = function()
      require('plugin-configs.formatter')
    end
  },
  -- access REPL
  {
    'hkupty/iron.nvim',
    config = function()
      require("plugin-configs.iron") -- access language REPL
    end
  },
  -- convert to multiline
  'AndrewRadev/splitjoin.vim',
  -- snippets
  'SirVer/ultisnips',
  -- integrate utilsnips with telescope
  'fhill2/telescope-ultisnips.nvim',
  -- better diagnostics
  {
    'folke/trouble.nvim',
    config = function ()
      require("plugin-configs.trouble")
    end
  },
  -- auto change matching html tags
  'AndrewRadev/tagalong.vim',
  -- autocomplete
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    },
    config = function()
      require("plugin-configs.nvim-cmp") -- autocomplete
    end
  },
  -- language specific plugins
  {
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require('go').setup()
    end,
  },
  -- indent guides
  'lukas-reineke/indent-blankline.nvim',
  -- Comment/uncomment multiple lines with <leader>c<space>
  {
    'terrortylor/nvim-comment',
    config = function()
      require("plugin-configs.nvim-comment")
    end
  },
  -- determine comment syntax by the line, full for embedded syntax typically in javascript frameworks
  'JoosepAlviste/nvim-ts-context-commentstring',
  -- fzf because it's the best fuzzy finder
  {
    'vijaymarupudi/nvim-fzf', -- lua api
    dependencies = {
      'vijaymarupudi/nvim-fzf-commands', -- actual vim commands
    },
    config = function()
      require('plugin-configs.fzf')
    end
  },
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function()
      require("plugin-configs.telescope") -- awesome fuzzy finder, but slower than fzf
    end
  },
  --  fzf in telescope instead of builtin fuzzy finder (fzf is much faster)
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- better telescope
  'nvim-telescope/telescope-ui-select.nvim',
  -- project management with telescope
  'nvim-telescope/telescope-project.nvim',
  -- ripgrep for fastest ever grep directly in vim
  'jremmen/vim-ripgrep',
  -- markdown preview
  {
    'iamcco/markdown-preview.nvim',
    build = ':call mkdp#util#install()',
    config = function()
      vim.g.mkdp_browser = 'google-chrome-stable'
      vim.g.mkdp_port = '4433'
    end
  },
  -- status line in lua
  'hoob3rt/lualine.nvim',
  -- tab line
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons'
    },
    init = function() vim.g.barbar_auto_setup = true end,
  },
  -- buffer switcher
  {
    'matbme/JABS.nvim',
    lazy = false,
    config = function()
      require("plugin-configs.JABS") -- buffer switcher
    end
  },
  -- emmet
  {
    'mattn/emmet-vim',
    config = function()
      require("plugin-configs.emmet") -- make writting html easier
    end
  },
  -- twig
  'nelsyeung/twig.vim',
  -- haskell
  'neovimhaskell/haskell-vim',
  -- rust
  'simrat39/rust-tools.nvim',
  -- Run terminal commands in floating windows
  'voldikss/vim-floaterm',
  -- best git commands integration for vim
  'tpope/vim-fugitive',
  -- git diff indications in gutter column
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("plugin-configs.gitsigns")
    end
  },
  -- .editorconfig file if found
  'editorconfig/editorconfig-vim',
  -- color highlighter
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup{}
    end
  },
  -- easyMotion clone for Nvim
  {
    'ggandor/leap.nvim',
    config=function()
      require('leap').add_default_mappings()
    end
  },
  -- shortcuts helper including registers, marks, keymaps, folds...
  {
    'folke/which-key.nvim',
    config = function()
      require("plugin-configs.which-key")
    end
  },
  -- highlight matching words
  {
    'RRethy/vim-illuminate',
    config = function()
      require("plugin-configs.vim-illuminate")
    end
  },
  -- treesitter the new language parser
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = "master",
    config = function()
      require("plugin-configs.treesitter")     end
  },
  -- debugging protocol
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require("plugin-configs.nvim-dap-virtual-text")    end
  },
  'nvim-treesitter/playground',
  -- semantic highlighting using treesitter
  {
    'm-demare/hlargs.nvim',
    config = function()
      require("plugin-configs.hlargs") -- semantic highlighting using treesitter
    end
  },
  -- documentation generator
  {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require("plugin-configs.neogen") -- doc comment generator
    end
  },
  -- bookmarks
  'MattesGroeger/vim-bookmarks',
  -- animations
  'echasnovski/mini.animate',
  {
    'echasnovski/mini.indentscope',
    config = function()
      require("plugin-configs.mini-indentscope")
    end
  },
  -- extra UI
  {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
  -- vim UI for messages, cmdline and popupmenu
  {
    "rcarriga/nvim-notify",
    config = function()
      require("plugin-configs.nvim-notify")    end
  },
  {
    'folke/noice.nvim',
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    },
    config = function()
      require('plugin-configs.noice')
    end
  },
  -- games
  'ThePrimeagen/vim-be-good', -- type :VimBeGood
  -- auto session management
  {
    'rmagatti/auto-session',
    config = function()
      require("plugin-configs.auto-session") -- auto-save session per cwd
    end
  },
  -- an aswesome helper for writting custom colorschemes for Nvim
  {
    'tjdevries/colorbuddy.vim',
    config = function()
      require("plugin-configs.colorbuddy")
    end
  },
})
