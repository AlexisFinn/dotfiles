-- ╭─────────────────────────────────────────────────────────╮
-- │ bootstrap LazyVim (plugin manager)                      │
-- ╰─────────────────────────────────────────────────────────╯
require("config.lazy")
-- ╭─────────────────────────────────────────────────────────╮
-- │ get colors right                                        │
-- ╰─────────────────────────────────────────────────────────╯
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
-- ╭─────────────────────────────────────────────────────────╮
-- │ general config                                          │
-- ╰─────────────────────────────────────────────────────────╯
require("config.settings")
-- ╭─────────────────────────────────────────────────────────╮
-- │ Autocmds                                                │
-- ╰─────────────────────────────────────────────────────────╯
require("config.autocmds")
-- ╭─────────────────────────────────────────────────────────╮
-- │ Custom Commands                                         │
-- ╰─────────────────────────────────────────────────────────╯
require("config.cmds.FormatJSON")
require("config.cmds.CRef")
-- ╭─────────────────────────────────────────────────────────╮
-- │ install plugins and set colorscheme                     │
-- ╰─────────────────────────────────────────────────────────╯
local colorschemes = require("config.colorschemes")

require("lazy").setup({
  { import = "plugins" },
  colorschemes.Swayed,
})
