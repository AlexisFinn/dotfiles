---- bootstrap LazyVim (plugin manager) -------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

---- get colors right -------------------------------------------------------------------
if vim.fn.has("termguicolors") == 1 then
-- vim.go.t_8f = "[[38;2;%lu;%lu;%lum"
-- vim.go.t_8b = "[[48;2;%lu;%lu;%lum"
	vim.opt.termguicolors = true
end

---- general config ---------------------------------------------------------------------
-- vim.cmd("set lazyredraw") -- less realtime, more performance
vim.cmd("set ttyfast") -- Speed up scrolling in Vim
-- vim.cmd('autocmd VimLeave * silent! :!pkill -f "phpactor"') -- kill all phpactor instances still running on quit

---- General settings ----
vim.keymap.set('n', '<space>', '<Nop>', {silent = true}) -- unuset <space> in normal mode
vim.g.mapleader = " " -- set <space> as leader
vim.g.maplocalleader = " " -- set <space> as local leader (this isn't really used)
vim.o.cursorline = false -- Enable highlighting of the current line
vim.g.loaded_netrw = 0 -- disable netrw
vim.g.loaded_netrwPlugin = 0 -- disable netrw
vim.o.ruler = true -- show percentage of file
vim.o.wrap = false -- don't wrap long lines
vim.o.showcmd = true -- show the commands (ex '2w' or '4b' ) in the bottom right
vim.o.incsearch = true -- cursor follows the results on search
vim.o.hlsearch = true -- highlight all search results after search
vim.o.ignorecase = true -- by default ignore case when searching
vim.o.smartcase = true -- if search contains an uppercase do a case-sensitive search
vim.o.expandtab = true -- expand tab to spaces
vim.o.shiftwidth = 2 -- expand tab to 2 spaces by default
vim.o.softtabstop = 2 -- expand tab to 2 spaces by default
vim.o.guifont = "Cascadia Code PL:h14" -- not using gui but some plugins might need this
--vim.o.list = true -- display whitespaces as characters when editing
vim.opt.listchars = { tab = ">>>", trail = "·", precedes = "←", extends = "→", eol = "↲", nbsp = "␣" }
vim.o.hidden = true -- hide inactive buffers instead of unloading them, without this you will need to save your changes before changing buffers
vim.o.swapfile = false -- disable creating swap files
vim.o.splitbelow = true -- create a split below
vim.o.relativenumber = true -- show line numbers relative to cursor position
-- vim.o.statuscolumn = "%l %r %s" -- customise status column with absolute linenumber, relative linenumber, status
vim.o.number = true -- show non-relative line number at cursor position
vim.o.clipboard = vim.o.clipboard .. "unnamedplus" -- use system clipboard by default
vim.o.colorcolumn = "120" -- set a color column at the 120-character mark
vim.o.backspace = "indent,eol,start"
vim.o.foldcolumn = "0" -- disable fold column
-- vim.o.numberwidth = 1 -- keep gutter as small as possible by reducing the line number width
vim.o.mouse = "a" -- set mouse mode to all modes (allows to use mouse)
vim.o.backupdir = "/home/alexis/.vim/backup//" -- double slashes at the end avoids name collision
vim.o.directory = "/home/alexis/.vim/swap//"
vim.o.undodir = "/home/alexis/.vim/undo//"
vim.o.cmdheight = 0
--vim.o.pumblend = 15 -- transparency for popup windows if you want (yay!)
vim.g.loaded_perl_provider = 0 -- disable perl provider
vim.o.timeoutlen = 300
vim.o.undolevels = 10000
vim.o.updatetime = 200 -- Save swap file (if any) and trigger CursorHold event
vim.o.foldmethod = "manual"
-- vim.o.foldmethod = "expr" -- custom fold method
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()" -- fold using treesitter
--use new experimental filetype detection
vim.g.do_filetype_lua = 1
vim.g.did_lead_filetypes = 0
---- Autocmds ---------------------------------------------------------------------

-- do syntax highlighting even in large files
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function ()
    vim.cmd.syntax("sync minlines=10000")
  end
})
-- unfold all folds in file by default
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function ()
    vim.cmd("normal zR")
  end
})

-- hilite yanked text for 0.1 seconds
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight wen yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", {clear = true}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

---- Custom Commands --------------------------------------------------------------

vim.api.nvim_create_user_command("FormatJSON", "%!python -m --no-ensure-ascii json.tool", {});
---- install plugins ----
require("plugins")
