---- bootstrap packer (plugin manager)
require 'packer-bootstrap'

---- install plugins ----
require 'plugins'
---- general config ----
require 'config'
---- general key mappings ----
require 'keymap'
---- set colorscheme ----
require 'colorscheme'
require 'plugin-configs/catppuccin'
---- plugins configs ----
require 'plugin-configs/nvim-lsputils' -- lsp helper
require 'plugin-configs/nvim-lspconfig' -- configure language server protocols
require 'plugin-configs/vim-go' -- configure golang plugin
require 'plugin-configs/trouble' -- show linter errors
require 'plugin-configs/nvim-cmp' -- autocomplete
require 'plugin-configs/formatter' -- format on save config
require 'plugin-configs/lsp-signature' -- function signature as you type
require 'plugin-configs/better-whitespace' -- highlight all trailing whitespaces, and trim them on save
require 'plugin-configs/indent-blankline' -- add line to make indentation easier to follow
require 'plugin-configs/fzf' -- ctrl+p will launch the fzf fuzzy finder
require 'plugin-configs/lualine' -- status line configuration
require 'plugin-configs/bufferline' -- buffer line (tabs)
-- require 'plugin-configs/nvim-bufbar' -- alternative buffer line
require 'plugin-configs/emmet' -- make writting html easier
require 'plugin-configs/colorizer' -- highlight colors in code
require 'plugin-configs/telescope' -- awesome fuzzy finder, but slower than fzf
--require 'plugin-configs/hop' -- hop to any word/line in the viewport easily (easymotion clone in lua)
require 'plugin-configs/lightspeed'
require 'plugin-configs/specs' -- animate the cursor when it changes position to follow it easier
require 'plugin-configs/which-key' -- shortucs auto-suggestions (pretty awesome)
require 'plugin-configs/vim-illuminate' -- highlight all instances of the word under the cursor
require 'plugin-configs/nerdcommenter' -- easily comment/uncomment lines of code
require 'colorscheme-picker' -- pick among installed colorschemes with live preview
require 'plugin-configs/treesitter' -- global syntax parser
require 'plugin-configs/rnvimr' -- ranger as file manager config
