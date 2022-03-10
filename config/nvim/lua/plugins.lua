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
  use 'ghifarit53/tokyonight-vim'
  use 'whatyouhide/vim-gotham'
  use 'cocopon/iceberg.vim'
  use 'pineapplegiant/spaceduck'
  use 'sainnhe/everforest'
  use 'junegunn/seoul256.vim'
  use ({'catppuccin/nvim', as = 'catppuccin'})
  -- some nice icons
  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'
  -- smooth scrolling
  use 'psliwka/vim-smoothie'
  -- Language Server Protocol integration (this is so cool)
  use 'neovim/nvim-lspconfig'
  -- auto-formatting
  --use 'lukas-reineke/lsp-format.nvim'
  use 'mhartington/formatter.nvim'
  -- convert to multiline
  use 'AndrewRadev/splitjoin.vim'
  -- snippets
  use 'SirVer/ultisnips'
  use 'fhill2/telescope-ultisnips.nvim' -- integrate utilsnips with telescope
  -- better diagnostics
  use 'folke/trouble.nvim'
  -- auto change matching html tags
  use 'AndrewRadev/tagalong.vim'
  -- better defaults for builtin lsp
  use {
    'RishabhRD/nvim-lsputils',
    requires = {'RishabhRD/popfix'}
  }
  -- autocomplete
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
  -- language specific plugins
  use {'ray-x/go.nvim'}
  -- show function signature as you type
  use 'ray-x/lsp_signature.nvim'
  -- indent guides
  use 'lukas-reineke/indent-blankline.nvim'
  -- Comment/uncomment multiple lines with <leader>c<space>
  use 'preservim/nerdcommenter'
  -- determine comment syntax by the line, usefull for embedded syntax typically in javascript frameworks
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  -- documentation generator
  use {'kkoomen/vim-doge', run = ':call doge#install()'}
  -- fzf because it's the best fuzzy finder
  -- I actually prefer using fzf directly rather than telescope
  use 'vijaymarupudi/nvim-fzf' -- lua api
  use 'vijaymarupudi/nvim-fzf-commands' -- actual vim commands
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
    }
  }
  -- use fzf in telescope instead of builtin fuzzy finder (fzf is much faster)
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  -- ripgrep for fastest ever grep directly in vim
  use 'jremmen/vim-ripgrep'
  -- markdown preview
  use 'npxbr/glow.nvim'
  -- status line in lua
  use 'hoob3rt/lualine.nvim'
  -- tab line
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  -- light alternative
  -- use 'ojroques/nvim-bufbar'
  -- emmet
  use 'mattn/emmet-vim'
  -- twig
  use 'nelsyeung/twig.vim'
  -- haskell
  use 'neovimhaskell/haskell-vim'
  -- Show trailing whitespaces in red
  use 'ntpeters/vim-better-whitespace'
  -- file manager
  --use 'vifm/vifm.vim' -- using vifm
  use 'kevinhwang91/rnvimr' -- using ranger
  -- Run terminal commands in floating windows
  --use 'voldikss/vim-floaterm'
  -- best git commands integration for vim
  use 'tpope/vim-fugitive'
  -- git diff indications in gutter column
  use 'airblade/vim-gitgutter'
  -- use .editorconfig file if found
  use 'editorconfig/editorconfig-vim'
  -- color highlighter
  use 'norcalli/nvim-colorizer.lua'
  -- easyMotion clone for newer Nvim 0.5
  --use 'phaazon/hop.nvim'
  use 'ggandor/lightspeed.nvim'
  -- show some animation on cursor jumping to ease following the cursor
  use 'edluffy/specs.nvim'
  -- discord rich presence
  --use 'andweeb/presence.nvim'
  -- shortcuts helper including registers, marks, keymaps, folds...
  use 'folke/which-key.nvim'
  -- highlight matching words
  use 'RRethy/vim-illuminate'
  -- treesitter the new language parser
  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'
  }
  -- games
  use 'ThePrimeagen/vim-be-good' -- type :VimBeGood
end)
