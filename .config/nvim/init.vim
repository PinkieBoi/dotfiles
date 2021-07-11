set nocompatible
filetype plugin indent on

" Vim-Plug Manager
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'                        "Status Line
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'                             "Fancy Start Screen
Plug 'vimwiki/vimwiki'                                "Vim-Wiki
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
" Tim Pope
Plug 'tpope/vim-fugitive'                             "Git Plugin
Plug 'tpope/vim-commentary'                           "Commenting in Vim
" Syntax & Styling
Plug 'sheerun/vim-polyglot'                           "Multi-language Syntax
Plug 'jiangmiao/auto-pairs'                           "Autoclose
Plug 'vim-python/python-syntax'                       "Got to have Python!
Plug 'ap/vim-css-color'                               "Displays the colour over the code
Plug 'kovetskiy/sxhkd-vim'                            "SXHKD Syntax
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'        "NerdTree
" They're Pretty
Plug 'frazrepo/vim-rainbow'                           "Easier to spot mistakes
Plug 'ryanoasis/vim-devicons'                         "I wanted them
Plug 'dracula/vim', { 'as': 'dracula' }               "Makes Vim pretty

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" General Settings
set path+=**
syntax on
colorscheme dracula
set t_Co=256
set number relativenumber
set cursorline
set ruler
set wrap
set cursorline
set clipboard+=unnamedplus
set cmdheight=1
set laststatus=2
set noshowmode
set backup
set noswapfile
set wildmenu
set nohlsearch
set incsearch
set ignorecase
set mouse=a
set langmenu=en_GB
set encoding=utf-8
set fileformat=unix
set backspace=indent,eol,start
set scrolloff=8
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set errorbells
set showbreak="¬"
set helpheight=30
set fillchars+=vert:¬

let g:rainbow_active = 1

" Enable persistent undo
if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  set undofile
endif


" Startify
let g:startify_session_dir = '~/.vim/session'
let g:startify_files_number = 6
let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   Recent Files']   },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]
let g:startify_skiplist = [
            \ '\.vimgolf',
            \ '^/tmp',
            \ '/project/.*/documentation',
            \ escape(fnamemodify($HOME, ':p'), '\') .'mysecret.txt',
            \ ]
let g:startify_bookmarks = [
            \ {'6': '~/.zshrc'},
            \ {'7': '~/.bashrc'},
            \ {'8': '~/.vimrc'},
            \ {'9': '~/.config/nvim/init.vim'},
            \ ]
let g:startify_custom_header = [
            \ "   ______ _       _    _     ______       _   ",
            \ "   | ___ (_)     | |  (_)    | ___ \\     (_)  ",
            \ "   | |_/ /_ _ __ | | ___  ___| |_/ / ___  _   ",
            \ "   |  __/| | '_ \\| |/ / |/ _ \\ ___ \\/ _ \\| |  ",
            \ "   | |   | | | | |   <| |  __/ |_/ / (_) | |  ",
            \ "   \\_|   |_|_| |_|_|\\_\\_|\\___\\____/ \\___/|_|  ",
            \ ]

" Status Line
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
  let g:airline_left_sep = ''
  let g:airline_right_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.crypt = '🔒'
  let g:airline_symbols.dirty='⚡'
  let g:airline_symbols.linenr = '☰ '
  let g:airline_symbols.maxlinenr = ' '
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.spell = 'Ꞩ'
  let g:airline_symbols.notexists = 'Ɇ'
  let g:airline_symbols.whitespace = 'Ξ'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#left_sep = ''


" Keys
let mapleader = "`"                    "Might as well use that key for something
autocmd FileType apache setlocal commentstring=#\ %s
" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Splits and Tabbed Files
set splitbelow splitright

" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Make adjusing split sizes a bit more friendly
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" Change 2 split windows from vert to horiz or horiz to vert
map <Leader>th <C-w>t<C-w>H
map <Leader>tk <C-w>t<C-w>K

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeNaturalSort=1
let NERDTreeCaseSensitiveSort=1
let g:NERDTreeWinSize=38

" VimWiki
let g:vimwiki_list = [{
            \ 'path': '~/vimwiki/',
            \ 'syntax': 'markdown',
            \ 'ext': '.md'
            \ }]

" File Encoding
setglobal termencoding=utf-8
scriptencoding utf-8

" Set Vim Language
let LANG='en_GB'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" => Colors
highlight Statement        ctermfg=2    ctermbg=none    cterm=none
highlight Directory        ctermfg=4    ctermbg=none    cterm=none
highlight Constant         ctermfg=12   ctermbg=none    cterm=bold
highlight Special          ctermfg=4    ctermbg=none    cterm=none
highlight Identifier       ctermfg=6    ctermbg=none    cterm=none
" highlight PreProc          ctermfg=5    ctermbg=none    cterm=none
highlight String           ctermfg=12   ctermbg=none    cterm=none
highlight Number           ctermfg=1    ctermbg=none    cterm=none
highlight Function         ctermfg=1    ctermbg=none    cterm=none
highlight htmlEndTag       ctermfg=114     ctermbg=none cterm=none
highlight xmlEndTag        ctermfg=114     ctermbg=none cterm=none
" highlight VertSplit        ctermfg=0    ctermbg=8       cterm=none
" highlight WildMenu         ctermfg=0       ctermbg=80   cterm=none
highlight Folded           ctermfg=103     ctermbg=234  cterm=italic
highlight FoldColumn       ctermfg=103     ctermbg=234  cterm=italic
" highlight DiffAdd          ctermfg=none    ctermbg=23   cterm=none
" highlight DiffChange       ctermfg=none    ctermbg=56   cterm=none
" highlight DiffDelete       ctermfg=168     ctermbg=96   cterm=none
" highlight DiffText         ctermfg=0       ctermbg=80   cterm=none
 
