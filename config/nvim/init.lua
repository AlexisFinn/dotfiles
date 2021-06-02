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
require('plugin-configs/treesitter')
require('plugin-configs/fzf')
require('plugin-configs/nvim-lspconfig')
require('plugin-configs/nvim-lsputils')
require('plugin-configs/lualine')
require('plugin-configs/emmet')
require('plugin-configs/better-whitespace')
require('plugin-configs/nvim-compe')
require('plugin-configs/telescope')
require('plugin-configs/barbar')
require('plugin-configs/php-cs-fixer')
require('plugin-configs/indent-guides')
