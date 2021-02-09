" File: .vimrc
" Author: Jake Zimmerman <jake@zimmerman.io>
"
" How I configure Vim :P
"
" Gotta be first
set nocompatible

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype off

"/ ------ ALE / COC working together -----------
let g:ale_disable_lsp = 1

call plug#begin('~/.config/nvim/plugged')
" ---------- GENERAL FUNCTIONALITY PLUGINS -----------
" a set of default configs and fixes to start of with
" Plug 'tpope/vim-sensible' (included in polyglot)
Plug 'sheerun/vim-polyglot'
" Lightweight and simple status line
Plug 'itchyny/lightline.vim'
" Comment/uncomment multiple lines with <leader>c<space>
Plug 'preservim/nerdcommenter'
" ctags manager for autocomplete
Plug 'ludovicchabant/vim-gutentags'
" emmet html abbreviations expansion for vim
Plug 'mattn/emmet-vim'
" php comlpetion, refactoring and introspection
"Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}
" allows to delete a buffer without closing the window
Plug 'rbgrouleff/bclose.vim'
" quick filtering of results
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" quickly move around a file using <leader><leader>
Plug 'easymotion/vim-easymotion'
" Show trailing whitespaces in red
Plug 'ntpeters/vim-better-whitespace'
" Indentation guides
Plug 'nathanaelkane/vim-indent-guides'
" vim Git wrapper
Plug 'tpope/vim-fugitive'
" syntax and snippets for dockerfiles
Plug 'ekalinin/Dockerfile.vim'
" show VCS changes in sign column beside opened file
Plug 'mhinz/vim-signify'
" auto-close braces etc..
Plug 'Raimondi/delimitMate'
" read and process .editorconfig file
Plug 'editorconfig/editorconfig-vim'
" Powerfull intellisense for vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-git', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-emmet', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-yank', {'do': 'yarn install --frozen-lockfile'}
"Plug 'marlonfan/coc-phpls', {'do': 'yarn install --frozen-lockfile'}
" auto trim trailing whitespace on save
Plug 'derekprior/vim-trimmer'
" Lightweight status bar
Plug 'mengelbrecht/lightline-bufferline'
" Ranger integration into vim
" Plug 'francoiscabrol/ranger.vim'
" Vifm integration
Plug 'vifm/vifm.vim'

" Display current file tags in side window
Plug 'majutsushi/tagbar'
" Highligt the enclosing or matching xml/html tags
Plug 'Valloric/MatchTagAlways'
" Autocorrect syntax using php-cs-fixer
Plug 'stephpy/vim-php-cs-fixer'
" Generate phpdoc blocks
Plug 'sumpygump/php-documentor-vim'
" Fuzzy find and open with Ctrl+p
"Plug 'ctrlpvim/ctrlp.vim'
" Preview color codes
Plug 'RRethy/vim-hexokinase', {'do': 'make'}
" Color picker
"Plug 'KabbAmine/vCoolor.vim'
" ----------- SYNTAX -------------
Plug 'evidens/vim-twig'
Plug 'cakebaker/scss-syntax.vim'
Plug 'posva/vim-vue'
"Plug 'leafgarland/typescript-vim'
Plug 'dense-analysis/ale'
" Plug 'neovimhaskell/haskell-vim'
" Plug 'davidhalter/jedi-vim'

" --------- Color Schemes -----------
Plug 'drewtempelmeyer/palenight.vim'
Plug 'jacoborus/tender.vim'
Plug 'dracula/vim'
Plug 'arcticicestudio/nord-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'kaicataldo/material.vim', {'branch': 'main'}
Plug 'haishanh/night-owl.vim'
Plug 'megantiu/true.vim'
Plug 'lifepillar/vim-wwdc16-theme'
Plug 'lifepillar/vim-wwdc17-theme'
Plug 'rakr/vim-one'
Plug 'doki-theme/doki-theme-vim'
Plug 'dylanaraps/wal.vim'

" --------- FUN -----------

call plug#end()

filetype plugin indent on

" ----- PERFORMANCE -----
" cool but way to many redraws
set cursorcolumn!
set cursorline!

" disable slow php syntax regexes
let php_html_load=0
let php_html_in_heredoc=0
let php_html_in_nowdoc=0

let php_sql_query=0
let php_sql_heredoc=0
let php_sql_nowdoc=0

" less realtime, more performance
set lazyredraw

" --- General settings ---
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set ignorecase
set smartcase
set expandtab
set list
set shiftwidth=2
set softtabstop=2
set hid
set mouse=a
set noswapfile
set splitright splitbelow
" un-comment to show lines as relative to cursor position
set number relativenumber

" Tell vim how many colors he can use
" Note that this is a hack in case the terminal was not recognised
" typically via tmux or tmate
" The proper solution is to correctly set the TERM environment variable
" either in your .bashrc/.zshrc or in your .tmux.conf/.tmate.conf, but
" if you can't edit those values for some reason then activate this hack

"set term=xterm-256colors
"set t_Co=256

if (has("termguicolors"))
  set termguicolors
endif

" correct syntax highlighting in large files
autocmd BufEnter * :syntax sync minlines=10000

syntax enable

" ----- hard mode (disable arrow keys) ----
"noremap <Up> <nop>
"noremap <Down> <nop>
"noremap <Left> <nop>
"noremap <Right> <nop>

" ----- Window title settings -----
function! GetProject()
  return substitute(getcwd(), '.*\/', '', 'g')
endfunction

set title
set titlestring=VIM:
set titlestring+=\ %{GetProject()}
"set titlestring+=\ -\ %t:L.%l
"set titlestring+=\ --\ %{FugitiveStatusline()}

" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
hi clear SignColumn

" ----- Inform noevim of pyhton path -----
let g:python_host_prog = '/usr/bin/python'
let g:pyhton3_host_prog = '/usr/bin/python3'

" ----- Colorscheme settings -----
" Toggle this to "light" for light colorscheme
set background=dark

" Uncomment the next line if your terminal is not configured for solarized
"let g:solarized_termcolors=256

" Gruvbox theme config
let g:gruvbox_italic=1
let g:gruvbox_italicize_strings=1
let g:gruvbox_contrast_light='soft'
let g:gruvbox_contrast_dark='soft'

" Palenight theme config
let g:palenight_terminal_italics=1

" Material theme config
let g:material_terminal_italics=1
" availabel material styles are
" 'default'
" 'palenight'
" 'ocean'
" 'lighter'
" 'darker'
" 'default-community'
" 'palenight-community'
" 'ocean-community'
" 'lighter-community'
" 'darker-community'
let g:material_theme_style = 'ocean'

" Set the colorscheme
"colorscheme palenight
colorscheme tender
"colorscheme nord
"colorscheme solarized
"colorscheme dracula
"colorscheme gruvbox
"colorscheme onedark
"colorscheme material
"colorscheme night-owl
"colorscheme yuri_dark
"colorscheme wal

" ----- Plugin-Specific Settings --------------------------------------
" ----- Coc-vim -----
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>F  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" ----- vim-indent-guides -----
let g:indent_guides_enable_on_vim_startup = 1

" ----- Gutentags -----
"let g:gutentags_add_default_project_roots = 0
"let g:gutentags_project_root = ['.editorconfig']
"let g:gutentags_cache_dir = expand('~/.cache/vim/ctags')
"let g:gutentags_generate_on_new = 1
"let g:gutentags_generate_on_missing = 1
"let g:gutentags_generate_on_write = 1
"let g:gutentags_generate_on_empty_buffer = 0

"let g:gutentags_ctags_extra_args = [
"            \ '--append=no',
"            \ '--exclude="*node_modules*"',
"            \ '--exclude="*vendor*"',
"            \ '--tag-relative=yes',
"            \ '--fields=+ailmnS',
"            \ ]

"let g:gutentags_trace = 0

let g:gutentags_exclute_filetypes = ['gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git']

"nmap <silent> gd :CtrlPTag<cr><c-\>w

" ----- syntastic settings -----
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"
augroup mySyntastic
  au!
  au FileType tex let b:syntastic_mode = "passive"
augroup END

" ----- majutsushi/tagbar settings -----
" Open/close tagbar with \b
nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
  au!
  au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
  au FileType tex let b:delimitMate_quotes = ""
  au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
  au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ----- php_cs_fixer -----
let g:php_cs_fixer_cache='.php_cs.cache'
let g:php_cs_fixer_config_file='.php_cs'
" auto fix on save
autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

" ----- ALE ------
let g:ale_javascript_prettier_use_local_config = 1
"let g:ale_pattern_options = {
"    \ '.*\.php$': {'ale_enabled': 0}
"\}
"let g:ale_linter_aliases = {'vue': ['typescript', 'html', 'scss']}
"let g:ale_linters = {'typescript': ['tsserver'], 'vuejs': ['vetur']}

" ----- mattn/emmet-vim settings -----
" remap expand to Ctrl+E & ,
let g:user_emmet_leader_key='<C-E>'
" enable emmet in all modes
let g:user_emmet_mode='inv'

" ----- ctrlP -----
"set wildignore+=*/node/*,*/var/*,*/cache/*,*/tmp/*

"let g:ctrl_p_custom_ignore = {
""    \ 'dir': '\.git$\|node_modules\|vendor$',
""    \ 'file': '\v.(exe|so|dll|png|jpg|jpeg)$',
""\}
" Include hidden dotfiles
"let g:ctrlp_show_hidden = 1
"let g:ctrlp_use_caching = 1
"let g:ctrlp_clear_cache_on_exit = 1
"let g:ctrlp_max_depth = 40
"let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
"let g:ctrlp_max_files = 40000

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
"let g:ctrlp_working_path_mode = 'r'

" Use a leader instead of the actual named binding
"nmap <C-p> :CtrlP<cr>

" Easy bindings for its various modes
"nmap <leader>bb :CtrlPBuffer<cr>
"nmap <leader>bm :CtrlPMixed<cr>

" instead of CtrlP why not just use fzf
nmap <C-p> :FZF<cr>
nmap <leader>s :FZF<cr>

" ----- vim-hexokinase ------
let g:Hexokinase_highlighters = ['virtual']

" ----- vim-vue -----
let g:vue_pre_processors = ['scss', 'typescript']

" ----- NERDCommenter -----
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:ft = ''
" This sets filetype according to current line in vuejs files so that
" commenting works properly
"function! NERDCommenter_before()
"    if &ft == 'vue'
"        let g:ft = 'vue'
"        let stack = synstack(line('.'), col('.'))
"        if len(stack) > 0
"            let syn = synIDattr((stack)[0], 'name')
"            if len(syn) > 0
"                exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
"            endif
"        endif
"    endif
"endfunction
"function! NERDCommenter_after()
"    if g:ft == 'vue'
"        setf vue
"        let g:ft = ''
"    endif
"endfunction

" ----- MatchTagAlways -----
let g:mta_use_matchparen_group = 1
let g:mta_filetypes = {'html' : 1,'html.twig' : 1,'vue' : 1,'js' : 1,'xhtml' : 1,'xml' : 1}

" ----- Coc-Prettier -----
"command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
"let g:prettier#autoformat = 0
"let g:prettier#config#config_precedence = 'file-override'
"let g:prettier#config#autoformat_config_present = 1
"let g:prettier#config#autoformat_config_files = ['.prettierrc']
"autocmd BufWritePost *.vue,*.ts,*.js,*.css,*.scss,*.json,*.html,*.md PrettierAsync
" max line length that prettier will wrap on
"let g:prettier#config#print_width = 120

" number of spaces per indentation level
"let g:prettier#config#tab_width = 4

" use tabs over spaces
"let g:prettier#config#use_tabs = 'false'

" print semicolons
"let g:prettier#config#semi = 'true'

" single quotes over double quotes
"let g:prettier#config#single_quote = 'true'

" print spaces between brackets
"let g:prettier#config#bracket_spacing = 'false'

" always|never|preserve
"let g:prettier#config#prose_wrap = 'preserve'

" ----- lightline -----
set laststatus=2
set showtabline=2
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'git', 'modified' ], ['cocst'] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers',
      \   'gutentags': 'gutentags#statusline',
      \   'cocst': 'coc#status'
      \ },
      \ 'component_function': {
      \   'git': 'FugitiveStatusline'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
\ }
" auto-update lightline on coc change
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

nmap <C-PageUp> :bp<CR>
nmap <C-PageDown> :bn<CR>
" ------- lightline-buffer --------
let g:lightline#bufferline#clickable=1
let g:lightline.component_raw = {'buffers': 1}

" ----- alexis/custom -----
"map <F9> :NnnPicker<CR>
"map <F9> :RangerCurrentFile<CR>
map <F9> :Vifm<CR>
"map <C-N> :tabnew<CR>
"noremap <C-W> :q<CR>
"vmap <C-c> \c <CR>

" Remap split window switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Remap \\ in visual mode to search for currently selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" use system clipboard
set clipboard+=unnamedplus

" Disable line wrapping
set nowrap
set sidescroll=5
set listchars=precedes:-,extends:+

" Auto save
set autowriteall
au FocusLost * :wa

" NO MORE EX MODE
nnoremap Q <nop>

" Remap buffer close
cnoreabbrev dd bd
:command! W w

" Add a command to reformat json
com! FormatJSON %!python -m json.tool

" configure custom indent per filetype
autocmd FileType vue setlocal shiftwidth=4 tabstop=4
