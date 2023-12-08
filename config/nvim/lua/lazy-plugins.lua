local lazyOptions = {
  ui = {
    border = "rounded",
  },
  performance = {
    cache = {enabled = true},
    rtp = {
      disabled_plugins = {
        -- "netrwPlugin",
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin"
      }
    }
  },
  debug = false,
}

local colorschemes = {
  AtomDark = {
    'gosukiwi/vim-atom-dark',
    function()
      vim.cmd.colorscheme 'atom-dark'
    end
  },
  Ayu = {
    'Shatur/neovim-ayu',
    function()
      require('ayu').setup({
        mirage = false 
      });
      vim.cmd.colorscheme 'ayu'
    end
  },
  Bamboo = {
    'ribru17/bamboo.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('bamboo').setup({
        style = 'multiplex', -- 'vulgaris'
        code_style = {
          comments = 'italic', -- 'italic,bold'
          conditionals = 'italic',
          functions = 'bold'
        }
      })
      vim.cmd.colorscheme 'bamboo'
    end
  },
  Catppuccin = {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          mini = false,
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          lsp_trouble = false,
          cmp = true,
          lsp_saga = false,
          gitgutter = false,
          gitsigns = true,
          telescope = true,
          nvimtree = {
            enabled = true,
            show_root = false,
          },
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
          dashboard = true,
          neogit = false,
          vim_sneak = false,
          fern = false,
          barbar = false,
          bufferline = true,
          markdown = true,
          lightspeed = false,
          ts_rainbow = false,
          hop = false,
          notify = true,
          telekasten = true,
        },
      })
      vim.cmd.colorscheme 'catppuccin'
    end
  },
  Dogrun = {
    'wadackel/vim-dogrun',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dogrun'
    end
  },
  DoomOne = {
    'romgrk/doom-one.vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'doom-one'
    end
  },
  Dracula = {
    'dracula/vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dracula'
    end
  },
  Everforest = {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'everforest'
    end
  },
  Forest = {
    'skullamortis/forest.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'forest'
    end
  },
  Gotham = {
    'whatyouhide/vim-gotham',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'gotham'
    end
  },
  GruvboxMaterial = {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- :help gruvbox-material.txt
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_sign_column_background = 'none'
      vim.cmd.colorscheme 'gruvbox-material'
    end
  },
  Iceberg = {
    'cocopon/iceberg.vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'iceberg'
    end
  },
  Kanagawa = {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'kanagawa'
    end
  },
  Material = {
    'marko-cerovac/material.nvim',
    config = function()
      vim.g.material_style = 'deep ocean' -- 'darker', 'lighter', 'palenight', 'oceanic', 'deep ocean'
      require('material').setup({
        styles = {
          comments = {italic = true},
          strings = {italic = true},
          keywords = {italic = true},
          functions = {italic = false, bold = true, undercurl = true},
          variables = {italic = false},
        },
        plugins = {
          "gitsigns",
          "nvim-cmp",
          "telescope",
          "trouble",
          "which-key"
        }
      })
      vim.cmd.colorscheme 'material'
    end,
  },
  Melange = {
    'savq/melange',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'melange'
    end
  },
  Mellow = {
    'kvrohit/mellow.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'mellow'
    end
  },
  Moonfly = {
    'bluz71/vim-moonfly-colors',
    lazy = false,
    name = 'moonfly',
    priority = 1000,
    config = function()
      vim.g.moonflyitalics = true
      vim.cmd.colorscheme 'moonfly'
    end
  },
  Neon = {
    'rafamadriz/neon',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.neon_style = 'dark' -- 'default', 'dark', 'doom', 'light'
      vim.g.neon_italic_keyword = true
      vim.g.neon_italic_function = true
      vim.g.neon_transparent = false
      vim.cmd.colorscheme 'neon'
    end
  },
  NightFox = {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({
        styles = {
          comments = "italic",
          keywords = "italic",
          types = "italic"
        }
      })
      vim.cmd.colorscheme 'nightfox'
    end
  },
  NightFly = {
    'bluz71/vim-nightfly-colors',
    lazy = false,
    priority = 1000,
    name = "nightfly",
    config = function()
      vim.cmd.colorscheme 'nightfly'
    end
  },
  NightOwl = {
    'oxfist/night-owl.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'night-owl'
    end
  },
  Nord = {
    'arcticicestudio/nord-vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'nord'
    end
  },
  OceanicNext = {
    'mhartington/oceanic-next',
    function()
      vim.cmd.colorscheme 'oceanic-next'
    end
  },
  One = {
  'rakr/vim-one',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'one'
  end
  },
  OneDark = {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  Palenight = {
    'drewtempelmeyer/palenight.vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'palenight'
    end
  },
  Seoul256 = {
    'junegunn/seoul256.vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'seoul256'
    end
  },
  ShadoTheme = {
    'Shadorain/shadotheme',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'shadotheme'
    end
  },
  Sonokai = {
    'sainnhe/sonokai',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'sonokai'
    end
  },
  Spaceduck = {
    'pineapplegiant/spaceduck',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'spaceduck'
    end
  },
  PaperColor = {
    'NLKNguyen/papercolor-theme',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'papercolor'
    end
  },
  Tender = {
    'jacoborus/tender.vim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tender'
    end
  },
  Tokyonight = {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight'
    end
  },
  Zenburn = {
    'jnurmine/Zenburn',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'zenburn'
    end
  },
}

require("lazy").setup({
  -------------------
  -- COLOR SCHEMES --
  -------------------
  -- colorschemes, load them first for proper integration with other plugins
  -- require("plugin-configs.colorschemes"),
  colorschemes.NightOwl,
  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },
  ---------------
  -- EYE CANDY --
  ---------------
  -- some nice icons
  require("plugin-configs.nvim-web-devicons"),
  -- smooth scrolling
  -- require("plugin-configs.vim-smoothie"),
  -- animated indent guides
  -- require("plugin-configs.mini-indentscope"),
  -- status line in lua
  require("plugin-configs.lualine"),
  -- tab line
  -- require("plugin-configs.barbar"),
  -- color highlighter
  -- require("plugin-configs.nvim-colorizer"),
  -- highlight matching words
  -- require("plugin-configs.vim-illuminate"),
  require("plugin-configs.strcursorword"),
  -- treesitter the new language parser
  require("plugin-configs.nvim-treesitter"),
  -- semantic highlighting using treesitter
  require("plugin-configs.hlargs"),
  -- vim UI for messages, cmdline and popupmenu
  -- require('plugin-configs.noice'),
  -- indent guides
  require('plugin-configs.indent-blankline'),
  ---------------
  -- LSP SETUP --
  ---------------
  -- Install LSP dependencies with Mason
  require("plugin-configs.mason-lspconfig"),
  -- auto lua lsp configuration. !! MUST COME BEFORE LSP-CONFIG
  -- require("plugin-configs.neodev"),
  -- Language Server Protocol integration (this is so cool)
  require("plugin-configs.nvim-lspconfig"),
  -- better defaults for builtin lsp
  require("plugin-configs.nvim-lsputils"),
  -- show function signature as you type
  require('plugin-configs.lsp-signature'),
  -- auto-formatting
  require('plugin-configs.formatter'),
  -- access language REPL
  require("plugin-configs.iron"),
  -- code snippets
  -- require("plugin-configs.utilsnips"),
  -- better diagnostics
  require("plugin-configs.trouble"),
  -- autocomplete
  require("plugin-configs.nvim-cmp"),
  -- debugging protocol
  -- require("plugin-configs.nvim-dap-virtual-text"),
  ----------------------------
  -- TELESCOPE FUZZY FINDER --
  ----------------------------
  -- fzf because it's the best fuzzy finder
  require('plugin-configs.nvim-fzf'),
  -- telescope, an awesome fuzzy-finder that leverages all the new nvim functions
  require("plugin-configs.nvim-telescope"),
  -- ripgrep for fastest ever grep directly in vim
  require("plugin-configs.vim-ripgrep"),
  -------------------------------
  -- LANGUAGE SPECIFIC PLUGINS --
  -------------------------------
  -- GoLang
  -- require("plugin-configs.go"),
  -- markdown preview
  require("plugin-configs.markdown-preview"),
  -- emmet
  require("plugin-configs.emmet"),
  -- twig
  require("plugin-configs.twig"),
  -- haskell
  -- require("plugin-configs.haskell-vim"),
  -- rust
  -- require("plugin-configs.rust-tools"),
  -- .editorconfig file if found
  require("plugin-configs.editorconfig-vim"),
  -- auto change matching html tags
  require("plugin-configs.tagalong"),
  -- Varnish Conif Language (VCL)
  require("plugin-configs.vim-varnish"),
  -- CSV
  require("plugin-configs.rainbow-csv"),
  --------
  -- AI --
  --------
  -- Codmium
  require("plugin-configs.codeium"),
  ------------------------
  -- FUNCTIONAL PLUGINS --
  ------------------------
  -- buffer switcher
  -- require("plugin-configs.JABS"),
  require("plugin-configs.reach-config"),
  -- require("plugin-configs.buffer_manager"),
  -- Comment/uncomment multiple lines with <leader>c<space>
  -- require("plugin-configs.nvim-comment"),
  -- require("plugin-configs.mini-comment"),
  require("plugin-configs.comment"),
  -- easyMotion clone for Nvim
  require("plugin-configs.leap"),
  -- Run terminal commands in floating windows
  require("plugin-configs.vim-floaterm"),
  -- doc comment generator
  require("plugin-configs.neogen"),
  -- auto session management per cwd
  require("plugin-configs.auto-session"),
  -- convert to multiline
  require("plugin-configs.splitjoin"),
  -- bookmarks
  require("plugin-configs.vim-bookmarks"),
  -- require("plugin-configs.reach-config"),
  -- file manager
  require("plugin-configs.oil-fm"),
  ---------
  -- GIT --
  ---------
  -- best git commands integration for vim
  -- require("plugin-configs.vim-fugitive"),
  -- git blame integration
  require("plugin-configs.blame"),
  -- git diff indications in gutter column
  require("plugin-configs.gitsigns"),
  -----------
  -- OTHER --
  -----------
  -- shortcuts helper including registers, marks, keymaps, folds...
  require("plugin-configs.which-key"),
  -- an aswesome helper for writting custom colorschemes for Nvim
  -- require("plugin-configs.colorbuddy"),
  -- games ( type :VimBeGood )
  require("plugin-configs.vim-be-good"),
}, lazyOptions)
