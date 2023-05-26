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
  'kyazdani42/nvim-web-devicons',
  'ryanoasis/vim-devicons',
  -- smooth scrolling
  'psliwka/vim-smoothie',
  ---------------
  -- LSP SETUP --
  ---------------
  -- manage installed lsp servers
  --  'williamboman/nvim-lsp-installer'
  -- Language Server Protocol integration (this is so cool)
  'neovim/nvim-lspconfig',
  -- better defaults for builtin lsp
  {
    'RishabhRD/nvim-lsputils',
    dependencies = { 'RishabhRD/popfix' }
  },
  -- show function signature as you type
  'ray-x/lsp_signature.nvim',
  -- auto-formatting
  -- 'lukas-reineke/lsp-format.nvim'
  'mhartington/formatter.nvim',
  -- access REPL
  'hkupty/iron.nvim',
  -- convert to multiline
  'AndrewRadev/splitjoin.vim',
  -- snippets
  'SirVer/ultisnips',
  'fhill2/telescope-ultisnips.nvim', -- integrate utilsnips with telescope
  -- better diagnostics
  'folke/trouble.nvim',
  -- auto change matching html tags
  'AndrewRadev/tagalong.vim',
  -- autocomplete
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-path',
  -- language specific plugins
  { 'ray-x/go.nvim' },
  -- indent guides
  'lukas-reineke/indent-blankline.nvim',
  -- Comment/uncomment multiple lines with <leader>c<space>
  -- 'preservim/nerdcommenter',
  'terrortylor/nvim-comment',
  -- determine comment syntax by the line, full for embedded syntax typically in javascript frameworks
  'JoosepAlviste/nvim-ts-context-commentstring',
  -- fzf beca it's the best fuzzy finder
  -- I actually prefer using fzf directly rather than telescope
  'vijaymarupudi/nvim-fzf', -- lua api
  'vijaymarupudi/nvim-fzf-commands', -- actual vim commands
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    }
  },
  --  fzf in telescope instead of builtin fuzzy finder (fzf is much faster)
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  -- better telescope
  --  'stevearc/dressing.nvim'
  'nvim-telescope/telescope-ui-select.nvim',
  -- project management with telescope
  'nvim-telescope/telescope-project.nvim',
  -- ripgrep for fastest ever grep directly in vim
  'jremmen/vim-ripgrep',
  -- markdown preview
  --  'npxbr/glow.nvim'
  { 'iamcco/markdown-preview.nvim', build = ':call mkdp#util#install()' },
  -- status line in lua
  'hoob3rt/lualine.nvim',
  -- tab line
  { 'akinsho/bufferline.nvim', version = "*", dependencies = 'kyazdani42/nvim-web-devicons' },
  -- buffer switcher
  'matbme/JABS.nvim',
  -- emmet
  'mattn/emmet-vim',
  -- twig
  'nelsyeung/twig.vim',
  -- haskell
  'neovimhaskell/haskell-vim',
  -- rust
  'simrat39/rust-tools.nvim',
  -- file manager
  -- 'vifm/vifm.vim' -- using vifm
  -- 'kevinhwang91/rnvimr', -- using ranger
  'kyazdani42/nvim-tree.lua', -- builtin
  -- Run terminal commands in floating windows
  'voldikss/vim-floaterm',
  -- best git commands integration for vim
  'tpope/vim-fugitive',
  --  'kdheepak/lazygit.nvim'
  -- git diff indications in gutter column
  -- 'airblade/vim-gitgutter',
  'lewis6991/gitsigns.nvim',
  --  .editorconfig file if found
  'editorconfig/editorconfig-vim',
  -- color highlighter
  'norcalli/nvim-colorizer.lua',
  -- easyMotion clone for Nvim
  'ggandor/leap.nvim',
  -- show some animation on cursor jumping to ease following the cursor
  --  'edluffy/specs.nvim'
  -- discord rich presence
  -- 'andweeb/presence.nvim'
  -- shortcuts helper including registers, marks, keymaps, folds...
  'folke/which-key.nvim',
  -- highlight matching words
  'RRethy/vim-illuminate',
  -- treesitter the new language parser
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', branch = "master" },
  'nvim-treesitter/playground',
  -- documentation generator
  -- {'kkoomen/vim-doge', run = ':call doge#install()'}
  { 'danymat/neogen', dependencies = 'nvim-treesitter/nvim-treesitter' },
  -- bookmarks
  'MattesGroeger/vim-bookmarks',
  -- animations
  'echasnovski/mini.animate',
  'echasnovski/mini.indentscope',
  -- vim UI library
  --  'MunifTanjim/nui.nvim'
  -- vim UI for messages, cmdline and popupmenu
  "rcarriga/nvim-notify",
  {
    'folke/noice.nvim',
    -- event = 'VimEnter',
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    }
  },
  -- games
  'ThePrimeagen/vim-be-good', -- type :VimBeGood
  -- discord rich presence integration
  --  'vimsence/vimsence'
  -- auto session management
  'rmagatti/auto-session',
  -- better keymaps, functions, commands all in a searchable and describable interface
  'mrjones2014/legendary.nvim',
  -- Emacs Org Mode for Vim
  --  { 'nvim-orgmode/orgmode', requires = 'nvim-treesitter/nvim-treesitter' }
  'tjdevries/colorbuddy.vim',
  -- focus mode
  'Pocco81/true-zen.nvim'
})
