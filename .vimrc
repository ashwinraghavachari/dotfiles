set t_Co=256 "256 color
set encoding=utf-8 "UTF-8 character encoding

" Tabs and spaces
set tabstop=2  "2 space tabs
set shiftwidth=2  "2 space shift
set softtabstop=2  "Tab spaces in no hard tab mode
set expandtab  " Expand tabs into spaces
set autoindent  "autoindent on new lines
set smarttab
" For py and js use 4 space indents
autocmd Filetype python setlocal ts=4 sw=4 expandtab

" Search is only case-sensitive if it has uppercase in it
set ignorecase  "Search ignoring case
set smartcase  "Search using smartcase
set incsearch  "Start searching immediately

set showmatch  "Highlight matching braces
set ruler  "Show bottom ruler
set equalalways  "Split windows equal size
set formatoptions=croq  "Enable comment line auto formatting
set wildignore+=*.o,*.obj,*.class,*.swp,*.pyc "Ignore junk files
set title  "Set window title to file
set hlsearch  "Highlight on search
set scrolloff=5  "Never scroll off
set wildmode=longest,list  "Better unix-like tab completion
set cursorline  "Highlight current line
set clipboard=unnamed  "Copy and paste from system clipboard
set lazyredraw  "Don't redraw while running macros (faster)
set autochdir  "Change directory to currently open file
set nocompatible  "Kill vi-compatibility
set wrap  "Visually wrap lines
set linebreak  "Only wrap on 'good' characters for wrapping
set backspace=indent,eol,start  "Better backspacing
set linebreak  "Intelligently wrap long files
set ttyfast  "Speed up vim
set nostartofline "Vertical movement preserves horizontal position
set number "Line numbers

" Strip whitespace from end of lines when writing file
autocmd BufWritePre * :%s/\s\+$//e

" For pasting
set pastetoggle=<F12>

" Syntax highlighting and stuff
filetype plugin indent on
syntax on

" Get rid of warning on save/exit typo
command WQ wq
command Wq wq
command W w
command Q q

" Pathogen to manage plugins
"execute pathogen#infect()

" Syntastic syntax checking!
" show list of errors and warnings on the current file
nmap <leader>e :Errors<CR>
" check also when just opened the file
let g:syntastic_check_on_open = 1
" put icons on the sign column
let g:syntastic_enable_signs = 1
" custom icons
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✖'
let g:syntastic_style_warning_symbol = '⚡'
" indent by 2
let g:syntastic_python_pylint_args = '--indent-string="  " --ignore=E111,E129,E731,E741'
let g:syntastic_python_flake8_args = '--max-line-length=80 --ignore=E111,E129,E731,E741'
let g:syntastic_python_checkers = ['pylama', 'pylint', 'python', 'flake8']
let g:syntastic_aggregate_errors = 1
" Use a compilation database rather than the default
let g:syntastic_cpp_checkers = ['clang']
let g:syntastic_c_clang_tidy_post_args = ""
let g:syntastic_c_clang_check_post_args = ""

" better backup, swap and undos storage
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set undolevels=3000
set undoreload=10000
set viminfo+=n~/.vim/dirs/viminfo
set noswapfile
" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif
