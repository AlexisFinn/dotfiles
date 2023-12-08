---- colorscheme configurations ----
vim.o.background = 'dark' -- 'dark', 'light'
-- material config --
vim.g.material_style = 'oceanic' -- 'darker', 'lighter', 'palenight', 'oceanic', 'deep ocean'
vim.g.material_italic_comments = true
vim.g.material_italic_keywords = true
vim.g.material_italic_functions = false
vim.g.material_italic_variables = false
vim.g.material_contrast = true
vim.g.material_borders = false
vim.g.material_disable_background = false
-- oceanic config --
vim.g.oceanic_next_terminal_bold = 1
vim.g.oceanic_next_terminal_italic = 1
-- neon config --
vim.g.neon_style = 'doom' -- 'default', 'doom', 'dark', 'light'
vim.g.neon_italic_comment = true
vim.g.neon_italic_keyword = true
vim.g.neon_italic_function = false
vim.g.neon_italic_boolean = false
vim.g.neon_italic_variable = false
vim.g.neon_bold = true
-- gruvbox-material config --
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_sign_column_background = 'none'
-- sonokai config --
vim.g.sonokai_style = 'espresso' -- 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_disable_italic_comment = 0
-- mellow config --
vim.g.mellow_italic_comments = true
vim.g.mellow_italic_keywords = false
vim.g.mellow_italic_booleans = false
vim.g.mellow_italic_functions = false
vim.g.mellow_italic_variables = false
vim.g.mellow_bold_comments = false
vim.g.mellow_bold_keywords = false
vim.g.mellow_bold_booleans = false
vim.g.mellow_bold_functions = false
vim.g.mellow_bold_variables = false
vim.g.mellow_transparent = false -- disable background color
-- catppuccin config --
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

-- setup bamboo
require('bamboo').setup({
  style = 'multiplex', -- 'vulgaris'
})


---- uncomment one ----
-- vim.cmd 'color material'
-- vim.cmd 'color dogrun'
-- vim.cmd 'color gruvbox-material'
-- vim.cmd 'color doom-one' -- *
-- vim.cmd 'color dracula'
-- vim.cmd 'color shado'
-- vim.cmd 'color night-owl'
-- vim.cmd 'color moonfly'
-- vim.cmd 'color OceanicNext' -- *
-- vim.cmd 'color neon'
-- vim.cmd 'color sonokai'
-- vim.cmd 'color nord'
-- vim.cmd 'color atom-dark'
-- vim.cmd 'color zenburn'
-- vim.cmd 'color PaperColor'
-- vim.cmd 'color tender'
-- vim.cmd 'color one' -- *
-- vim.cmd 'color palenight' -- *
-- vim.cmd 'color catppuccin' -- *
-- vim.cmd 'color tokyonight' -- *
-- vim.cmd 'color tokyonight-night'
-- vim.cmd 'color tokyonight-storm'
-- vim.cmd 'color tokyonight-day'
-- vim.cmd 'color tokyonight-moon'
-- vim.cmd 'color gotham'
-- vim.cmd 'color iceberg' -- *
-- vim.cmd 'color spaceduck' -- *
-- vim.cmd 'color everforest'
-- vim.cmd 'color seoul256'
-- vim.cmd 'color nightfox'
-- vim.cmd 'color dayfox'
-- vim.cmd 'color dawnfox'
-- vim.cmd 'color duskfox'
-- vim.cmd 'color nordfox'
-- vim.cmd 'color terafox'
-- vim.cmd 'color ayu'
-- vim.cmd 'color melange'
-- vim.cmd 'color kanagawa' -- *
-- vim.cmd 'color mellow'
-- vim.cmd 'color quiet'
-- vim.cmd 'color nightfly'
vim.cmd 'color bamboo'
-- vim.cmd 'color forest'
