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
  -- Language Server Protocol integration (this is so cool)
  use 'neovim/nvim-lspconfig'
  -- better defaults for builtin lsp
  use {
    'RishabhRD/nvim-lsputils',
    requires = {'RishabhRD/popfix'}
  }
  -- autocomplete
  use 'hrsh7th/nvim-compe'
  -- some nice icons
  use 'kyazdani42/nvim-web-devicons'
  -- manage registers (clipboard)
  use 'junegunn/vim-peekaboo'
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
  -- vifm integration into vim
  use 'vifm/vifm.vim'
  -- best git integration into vim, must intall https://github.com/jesseduffield/lazygit
  use 'kdheepak/lazygit.nvim'
  -- git diff indications in gutter column
  use 'airblade/vim-gitgutter'
  -- use .editorconfig file if found
  use 'editorconfig/editorconfig-vim'
  -- color highlighter
  use 'norcalli/nvim-colorizer.lua'
  -- cursor highlighter
  use 'yamatsum/nvim-cursorline'
  -- easyMotion clone for newer Nvim 0.5
  use 'phaazon/hop.nvim'
  -- show some animation on cursor jumping to ease following the cursor
  use 'edluffy/specs.nvim'
  -- treesitter the new language parser
  use {
    'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'
  }
end)
