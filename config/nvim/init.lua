---- bootstrap packer (plugin manager)
require('packer-bootstrap')

---- plugins
require('plugins')
---- cutom configs
require('config')
-- mapping
require('keymap')
-- colorscheme
require('colorscheme')
-- plugins
require('plugin-configs/nvim-lspconfig')
require('plugin-configs/nvim-lsputils')
require('plugin-configs/nvim-compe')
require('plugin-configs/better-whitespace')
require('plugin-configs/php-cs-fixer')
require('plugin-configs/indent-guides')
require('plugin-configs/fzf')
require('plugin-configs/lualine')
require('plugin-configs/peekaboo')
require('plugin-configs/emmet')
require('plugin-configs/barbar')
require('plugin-configs/colorizer')
require('plugin-configs/vim-fugitive')
require('plugin-configs/telescope')
require('plugin-configs/hop')
require('plugin-configs/specs')
require('plugin-configs/treesitter')
