require("lazy").setup({
  -------------------
  -- COLOR SCHEMES --
  -------------------
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
  ---------------
  -- EYE CANDY --
  ---------------
  -- some nice icons
  'nvim-tree/nvim-web-devicons',
  'ryanoasis/vim-devicons',
  -- cursor jump animation
  {
    'echasnovski/mini.animate',
    config = function ()
      require('mini.animate').setup {}
    end,
    enabled = true
  },
  -- animated indent guides
  {
    'echasnovski/mini.indentscope',
    config = function()
      require("plugin-configs.mini-indentscope")
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
  -- color highlighter
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup{}
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
    dependencies = {
      'nvim-treesitter/playground',
    },
    config = function()
      require("plugin-configs.treesitter")
    end
  },
  -- semantic highlighting using treesitter
  {
    'm-demare/hlargs.nvim',
    config = function()
      require("plugin-configs.hlargs") -- semantic highlighting using treesitter
    end
  },
  -- vim UI for messages, cmdline and popupmenu
  {
    'folke/noice.nvim',
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        config = function()
          require("plugin-configs.nvim-notify")    end
        },
      },
      config = function()
        require('plugin-configs.noice')
      end
  },
  -- indent guides
  'lukas-reineke/indent-blankline.nvim',
  ---------------
  -- LSP SETUP --
  ---------------
  -- Install LSP dependencies with Mason
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
        config = function()
          require("mason").setup()
        end
      },
      'neovim/nvim-lspconfig'
    },
    config = function()
      require("plugin-configs.mason-lspconfig")
    end
  },
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
  -- utilsnips
  {
    'fhill2/telescope-ultisnips.nvim',
    dependencies = 'SirVer/ultisnips'
  },
  -- better diagnostics
  {
    'folke/trouble.nvim',
    config = function ()
      require("plugin-configs.trouble")
    end
  },
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
      require("plugin-configs.nvim-cmp")
    end
  },
  -- debugging protocol
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require("plugin-configs.nvim-dap-virtual-text")
    end
  },
  ----------------------------
  -- TELESCOPE FUZZY FINDER --
  ----------------------------
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
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-project.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require("plugin-configs.telescope") -- awesome fuzzy finder, but slower than fzf
    end
  },
  -- ripgrep for fastest ever grep directly in vim
  'jremmen/vim-ripgrep',
  -------------------------------
  -- LANGUAGE SPECIFIC PLUGINS --
  -------------------------------
  -- GoLang
  {
    'ray-x/go.nvim',
    dependencies = {
      {'ray-x/guihua.lua', build = 'cd lua/fzy && make'},
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter'
    },
    config = function()
      require('go').setup()
    end,
  },
  -- markdown preview
  {
    'iamcco/markdown-preview.nvim',
    build = ':call mkdp#util#install()',
    config = function()
      vim.g.mkdp_browser = 'google-chrome-stable'
      vim.g.mkdp_port = '4433'
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
  -- .editorconfig file if found
  'editorconfig/editorconfig-vim',
  -- auto change matching html tags
  'AndrewRadev/tagalong.vim',
  ------------------------
  -- FUNCTIONAL PLUGINS --
  ------------------------
  -- buffer switcher
  {
    'matbme/JABS.nvim',
    lazy = false,
    config = function()
      require("plugin-configs.JABS") -- buffer switcher
    end
  },
  -- Comment/uncomment multiple lines with <leader>c<space>
  {
    'terrortylor/nvim-comment',
    dependencies = {
      -- determine comment syntax by the line, full for embedded syntax typically in javascript frameworks
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require("plugin-configs.nvim-comment")
    end
  },
  -- easyMotion clone for Nvim
  {
    'ggandor/leap.nvim',
    config=function()
      require('leap').add_default_mappings()
    end
  },
  -- Run terminal commands in floating windows
  'voldikss/vim-floaterm',
  -- documentation generator
  {
    'danymat/neogen',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require("plugin-configs.neogen") -- doc comment generator
    end
  },
  -- auto session management per cwd
  {
    'rmagatti/auto-session',
    config = function()
      require("plugin-configs.auto-session")
    end
  },
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
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require("plugin-configs.gitsigns")
    end
  },
  -----------
  -- OTHER --
  -----------
  -- an aswesome helper for writting custom colorschemes for Nvim
  {
    'tjdevries/colorbuddy.vim',
    config = function()
      require("plugin-configs.colorbuddy")
    end
  },
  -- games
  'ThePrimeagen/vim-be-good', -- type :VimBeGood
})
