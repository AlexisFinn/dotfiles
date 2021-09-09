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
  -- some nice icons
  use 'kyazdani42/nvim-web-devicons'
  use 'ryanoasis/vim-devicons'
  -- Language Server Protocol integration (this is so cool)
  use 'neovim/nvim-lspconfig'
  -- snippets
  use 'SirVer/ultisnips'
  use 'fhill2/telescope-ultisnips.nvim' -- integrate utilsnips with telescope
  use 'honza/vim-snippets'
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
  use 'hrsh7th/nvim-compe'
  -- indent guides
  use 'glepnir/indent-guides.nvim'
  -- rainbow parentheses
  use 'p00f/nvim-ts-rainbow'
  -- Comment/uncomment multiple lines with <leader>c<space>
  use 'preservim/nerdcommenter'
  -- fzf because it's the best fuzzy finder
  -- I actually prefer using fzf directly than telescope
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
  -- ripgrep for fastest ever grep directly in vim
  use 'jremmen/vim-ripgrep'
  -- markdown preview
  use 'npxbr/glow.nvim'
  -- status line in lua
  use 'hoob3rt/lualine.nvim'
  -- tab line
  --use 'romgrk/barbar.nvim'
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  -- php-cs-fixer
  use 'aeke/vim-php-cs-fixer'
  -- emmet
  use 'mattn/emmet-vim'
  -- twig
  use 'qbbr/vim-twig'
  -- haskell
  use 'neovimhaskell/haskell-vim'
  -- Show trailing whitespaces in red
  use 'ntpeters/vim-better-whitespace'
  -- vifm integration into vim
  use 'vifm/vifm.vim'
  -- best git commands integration for vim
  use 'tpope/vim-fugitive'
  -- git diff indications in gutter column
  use 'airblade/vim-gitgutter'
  -- use .editorconfig file if found
  use 'editorconfig/editorconfig-vim'
  -- color highlighter
  use 'norcalli/nvim-colorizer.lua'
  -- cursor highlighter
--  use 'yamatsum/nvim-cursorline'
  -- easyMotion clone for newer Nvim 0.5
  use 'phaazon/hop.nvim'
  -- show some animation on cursor jumping to ease following the cursor
  use 'edluffy/specs.nvim'
  -- discord rich presence
  use 'andweeb/presence.nvim'
  -- shortcuts helper including registers, marks, keymaps, folds...
  use 'folke/which-key.nvim'
  -- highlight matching words
  use 'RRethy/vim-illuminate'
  -- treesitter the new language parser
  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'
  }
end)
