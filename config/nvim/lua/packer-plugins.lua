local packer = require 'packer'
return packer.startup(function(use)
  -- packer can manage itself
  use 'wbthomason/packer.nvim'
  -- colorschemes, load them first for proper integration with other plugins
  use 'mhartington/oceanic-next'
  use 'dracula/vim'
  use 'haishanh/night-owl.vim'
  use 'Shadorain/shadotheme'
  use 'bluz71/vim-moonfly-colors'
  use 'rafamadriz/neon'
  use 'marko-cerovac/material.nvim'
  use 'sainnhe/gruvbox-material'
  use 'sainnhe/sonokai'
  use 'romgrk/doom-one.vim'
  use 'wadackel/vim-dogrun'
  use 'arcticicestudio/nord-vim'
  use 'jnurmine/Zenburn'
  use 'gosukiwi/vim-atom-dark'
  use 'NLKNguyen/papercolor-theme'
  use 'jacoborus/tender.vim'
  use 'rakr/vim-one'
  use 'drewtempelmeyer/palenight.vim'
  use 'folke/tokyonight.nvim'
  use 'whatyouhide/vim-gotham'
  use 'rebelot/kanagawa.nvim'
  use 'cocopon/iceberg.vim'
  use 'pineapplegiant/spaceduck'
  use 'sainnhe/everforest'
  use 'junegunn/seoul256.vim'
  use 'EdenEast/nightfox.nvim'
  use 'ayu-theme/ayu-vim'
  use 'savq/melange'
  use({ 'catppuccin/nvim', as = 'catppuccin' })
  use 'kvrohit/mellow.nvim'
  -- some nice icons
  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'
  -- smooth scrolling
  use 'psliwka/vim-smoothie'
  ---------------
  -- LSP SETUP --
  ---------------
  -- manage installed lsp servers
  -- use 'williamboman/nvim-lsp-installer'
  -- Language Server Protocol integration (this is so cool)
  use 'neovim/nvim-lspconfig'
  -- better defaults for builtin lsp
  use {
    'RishabhRD/nvim-lsputils',
    requires = { 'RishabhRD/popfix' }
  }
  -- show function signature as you type
  use 'ray-x/lsp_signature.nvim'
  -- auto-formatting
  --use 'lukas-reineke/lsp-format.nvim'
  use 'mhartington/formatter.nvim'
  -- access REPL
  use 'hkupty/iron.nvim'
  -- convert to multiline
  use 'AndrewRadev/splitjoin.vim'
  -- snippets
  use 'SirVer/ultisnips'
  use 'fhill2/telescope-ultisnips.nvim' -- integrate utilsnips with telescope
  -- better diagnostics
  use 'folke/trouble.nvim'
  -- auto change matching html tags
  use 'AndrewRadev/tagalong.vim'
  -- autocomplete
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-path'
  -- language specific plugins
  use { 'ray-x/go.nvim' }
  -- indent guides
  use 'lukas-reineke/indent-blankline.nvim'
  -- Comment/uncomment multiple lines with <leader>c<space>
  use 'preservim/nerdcommenter'
  -- determine comment syntax by the line, usefull for embedded syntax typically in javascript frameworks
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  -- fzf because it's the best fuzzy finder
  -- I actually prefer using fzf directly rather than telescope
  use 'vijaymarupudi/nvim-fzf' -- lua api
  use 'vijaymarupudi/nvim-fzf-commands' -- actual vim commands
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    }
  }
  -- use fzf in telescope instead of builtin fuzzy finder (fzf is much faster)
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- better telescope
  -- use 'stevearc/dressing.nvim'
  use 'nvim-telescope/telescope-ui-select.nvim'
  -- project management with telescope
  use 'nvim-telescope/telescope-project.nvim'
  -- ripgrep for fastest ever grep directly in vim
  use 'jremmen/vim-ripgrep'
  -- markdown preview
  -- use 'npxbr/glow.nvim'
  use { 'iamcco/markdown-preview.nvim', run = ':call mkdp#util#install()' }
  -- status line in lua
  use 'hoob3rt/lualine.nvim'
  -- tab line
  use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons' }
  -- buffer switcher
  use 'matbme/JABS.nvim'
  -- emmet
  use 'mattn/emmet-vim'
  -- twig
  use 'nelsyeung/twig.vim'
  -- haskell
  use 'neovimhaskell/haskell-vim'
  -- rust
  use 'simrat39/rust-tools.nvim'
  -- file manager
  --use 'vifm/vifm.vim' -- using vifm
  use 'kevinhwang91/rnvimr' -- using ranger
  use 'kyazdani42/nvim-tree.lua' -- builtin
  -- Run terminal commands in floating windows
  use 'voldikss/vim-floaterm'
  -- best git commands integration for vim
  use 'tpope/vim-fugitive'
  -- use 'kdheepak/lazygit.nvim'
  -- git diff indications in gutter column
  use 'airblade/vim-gitgutter'
  -- use .editorconfig file if found
  use 'editorconfig/editorconfig-vim'
  -- color highlighter
  use 'norcalli/nvim-colorizer.lua'
  -- easyMotion clone for Nvim
  use 'ggandor/leap.nvim'
  -- show some animation on cursor jumping to ease following the cursor
  -- use 'edluffy/specs.nvim'
  -- discord rich presence
  --use 'andweeb/presence.nvim'
  -- shortcuts helper including registers, marks, keymaps, folds...
  use 'folke/which-key.nvim'
  -- highlight matching words
  use 'RRethy/vim-illuminate'
  -- treesitter the new language parser
  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', branch = "master"
  }
  use 'nvim-treesitter/playground'
  -- documentation generator
  --use {'kkoomen/vim-doge', run = ':call doge#install()'}
  use { 'danymat/neogen', requires = 'nvim-treesitter/nvim-treesitter' }
  -- bookmarks
  use 'MattesGroeger/vim-bookmarks'
  -- animations
  use 'echasnovski/mini.animate'
  use 'echasnovski/mini.indentscope'
  -- vim UI library
  -- use 'MunifTanjim/nui.nvim'
  -- vim UI for messages, cmdline and popupmenu
  use "rcarriga/nvim-notify"
  use {
    'folke/noice.nvim',
    -- event = 'VimEnter',
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    }
  }
  -- games
  use 'ThePrimeagen/vim-be-good' -- type :VimBeGood
  -- discord rich presence integration
  -- use 'vimsence/vimsence'
  -- auto session management
  use 'rmagatti/auto-session'
 -- use { 'rmagatti/session-lens', requires = {'rmagatti/auto-session', 'nvim-telescope/telescope.nvim'}}
  -- better keymaps, functions, commands all in a searchable and describable interface
  use 'mrjones2014/legendary.nvim'
  -- Emacs Org Mode for Vim
  -- use { 'nvim-orgmode/orgmode', requires = 'nvim-treesitter/nvim-treesitter' }
  use 'tjdevries/colorbuddy.vim'
end)
