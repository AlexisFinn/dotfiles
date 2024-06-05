return {
  AtomDark = {
    'gosukiwi/vim-atom-dark',
    function()
      vim.cmd.colorscheme 'atom-dark'
    end
  },
  Ayu = {
    'Shatur/neovim-ayu',
    config = function()
      require('ayu').setup({
        mirage = false
      })
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
  CyberDream = {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
      })
      vim.cmd("colorscheme cyberdream") -- set the colorscheme
    end,
  },
  DarkPlus = {
    'lunarvim/darkplus.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'darkplus'
    end
  },
  Distinct = {
    "https://gitlab.com/bartekjaszczak/distinct-nvim",
    priority = 1000,
    config = function()
        require("distinct").setup({
            doc_comments_different_color = true, -- Use different colour for documentation comments
        })

        vim.cmd("colorscheme distinct")
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
  EverGarden = {
    'crispybaccoon/evergarden',
    opt = {
      transparent_background = false,
      contrast_dark = 'medium', -- 'hard'|'medium'|'soft'
      override_terminal = true,
      style = {
        tabline = { reverse = true, color = 'green' },
        search = { reverse = false, inc_reverse = true },
        types = { italic = true },
        keyword = { italic = true },
        comment = { italic = false },
      },
      overrides = { }, -- add custom overrides
    },
    config = function()
      vim.cmd.colorscheme 'evergarden'
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
  HalfSpace = {
    url = "https://gitlab.com/sxwpb/halfspace.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'halfspace'
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
  Midnight = {
    'dasupradyumna/midnight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'midnight'
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
      require('onedark').setup({
        style = 'deep', -- 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
      })
      require('onedark').load()
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
      vim.cmd.colorscheme 'tokyonight-night'
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
