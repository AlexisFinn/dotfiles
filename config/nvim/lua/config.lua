-- get colors right
vim.api.nvim_command('set termguicolors')
-- less realtime, more performance
vim.api.nvim_command('set lazyredraw')
-- Speed up scrolling in Vim
vim.api.nvim_command('set ttyfast')
--- General settings ---
vim.api.nvim_command('set ruler') -- show percentage of file
vim.api.nvim_command('set nowrap') -- don't wrap long lines
vim.api.nvim_command('set showcmd') -- show the commands (ex '2w' or '4b' ) in the bottom right
vim.api.nvim_command('set incsearch') -- cursor follows the results on search
vim.api.nvim_command('set hlsearch') -- highlight all search results after search
vim.api.nvim_command('set ignorecase') -- by default ignore case when searching
vim.api.nvim_command('set smartcase') -- if search contains an uppercase do a case-sensitive search
vim.api.nvim_command('set expandtab') -- expand tab to spaces
--vim.api.nvim_command('set list') -- display whitespaces as characters when editing
--vim.api.nvim_command('set listchars = "tab:>,trail:.,nbsp:+"') -- customise characters used for whitespaces
vim.api.nvim_command('set hid') -- hide inactive buffers instead of unloading them
vim.api.nvim_command('set noswapfile') -- disable creating swap files
vim.api.nvim_command('set splitbelow') -- create a split below
vim.api.nvim_command('set relativenumber') -- show line numbers relative to cursor position
vim.api.nvim_command('set number') -- show real line number for current line
vim.api.nvim_command('set clipboard+=unnamedplus') -- use system clipboard by default
vim.o.backspace = 'indent,eol,start'
vim.o.foldcolumn = '1' -- gutter left padding
vim.o.numberwidth = 1 -- keep gutter as small as possible by reducing the line number width
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.mouse = 'a'
vim.o.backupdir = '/home/alexis/.vim/backup//' -- double slashes at the end avoids name collision
vim.o.directory = '/home/alexis/.vim/swap//'
vim.o.undodir = '/home/alexis/.vim/undo//'
vim.o.updatetime = 1000 -- number of miliseconds before updating, usefull for CursorHold autocmd
--vim.o.pumblend = 15 -- transparency for popup windows if you want (yay!)
