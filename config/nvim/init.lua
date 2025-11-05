-- ╭─────────────────────────────────────────────────────────╮
-- │ bootstrap LazyVim (plugin manager)                      │
-- ╰─────────────────────────────────────────────────────────╯
require("config.base")
-- ╭─────────────────────────────────────────────────────────╮
-- │ get colors right                                        │
-- ╰─────────────────────────────────────────────────────────╯
if vim.fn.has("termguicolors") == 1 then vim.opt.termguicolors = true end
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
require("config.cmds.YarnBuild")
-- ╭─────────────────────────────────────────────────────────╮
-- │ LSP                                                     │
-- ╰─────────────────────────────────────────────────────────╯
require("config.lsp")
-- vim.lsp.config("biome")
-- vim.lsp.config("lua-language-server")
-- ╭─────────────────────────────────────────────────────────╮
-- │ install plugins and set colorscheme                     │
-- ╰─────────────────────────────────────────────────────────╯
local colorschemes = require("config.colorschemes")

require("lazy").setup({
    spec = {{import = "plugins"}, colorschemes.Tame},
    change_detection = {enabled = false}
})

vim.cmd.colorscheme("tame")
