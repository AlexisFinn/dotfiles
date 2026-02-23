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
require("config.cmds.Cfp")
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
    spec = {{import = "plugins"}, colorschemes.Swayed},
    change_detection = {enabled = false},
    performance = {
        rtp = {
            disabled_plugins = {
                -- "matchit", 
                -- "matchparen", 
                "editorconfig", "man", "spellfile", "gzip", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin", "net", "osc52"
                -- "shada", "rplugin"
            }
        }
    }
})

-- vim.cmd.colorscheme("tame")
vim.cmd.colorscheme("swayed")
-- vim.cmd.colorscheme("gpt5mini")
-- vim.cmd.colorscheme("sonnet")
