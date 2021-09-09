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

---- uncomment one ----

--vim.cmd 'color material'
--vim.cmd 'color dogrun'
vim.cmd 'color gruvbox-material'
--vim.cmd 'color doom-one'
--vim.cmd 'color dracula'
--vim.cmd 'color xshado'
--vim.cmd 'color night-owl'
--vim.cmd 'color moonfly'
--vim.cmd 'color OceanicNext'
--vim.cmd 'color neon'

