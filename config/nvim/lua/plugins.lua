return require('packer').startup(function(use)
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
  -- indent guides
  use 'glepnir/indent-guides.nvim'
  -- Comment/uncomment multiple lines with <leader>c<space>
  use 'preservim/nerdcommenter'
  -- fzf because it's the best
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
  -- Language Server Protocol integration (this is so cool)
  use 'neovim/nvim-lspconfig'
  -- better defaults for builtin lsp
  use {
    'RishabhRD/nvim-lsputils',
    requires = {'RishabhRD/popfix'}
  }
  -- treesitter the new language parser
  use {
    'nvim-treesitter/nvim-treesitter'
  }
  -- status line in lua
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  -- tab line
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  -- php-cs-fixer
  use 'aeke/vim-php-cs-fixer'
  -- emmet
  use 'mattn/emmet-vim'
  -- twig
  use 'qbbr/vim-twig'
  -- Show trailing whitespaces in red
  use 'ntpeters/vim-better-whitespace'
  -- autocomplet
  use 'hrsh7th/nvim-compe'
  -- vifm integration into vim
  use 'vifm/vifm.vim'
  -- best git integration into vim
  use 'tpope/vim-fugitive'
  -- git diff indications in gutter column
  use 'airblade/vim-gitgutter'
  -- use .editorconfig file if found
  use'editorconfig/editorconfig-vim'
end)
