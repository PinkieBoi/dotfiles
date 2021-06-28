set nocompatible
filetype plugin indent on

" Vim-Plug Manager
call plug#begin()

Plug 'vim-airline/vim-airline'                        "Status Line
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/vim-startify'                       "Fancy Start Screen
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
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown'}
Plug 'kovetskiy/sxhkd-vim'                            "SXHKD Syntax
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'        "NerdTree
" They're Pretty
Plug 'frazrepo/vim-rainbow'                           "Easier to spot mistakes
Plug 'ryanoasis/vim-devicons'                         "I wanted them
Plug 'dracula/vim', { 'as': 'dracula' }               "Makes Vim pretty

call plug#end()


" General Settings
set path+=**
syntax on
colorscheme dracula                     "Vim colorscheme
set number relativenumber               "Fancy line numbers
set cursorline                          "Highlight cursor line for easy navigation
set wrap                                "Wrap long lines
set showbreak="¬"
set scrolloff=3                         "Scroll 3 lns before edge of viewport
set clipboard+=unnamedplus              "Clipboard
set laststatus=2                        "Always show statusline
set noshowmode                          "Prevent modes displaying twice
set noswapfile                          "No swap file
set wildmenu
set incsearch                           "Incremental search
set mouse=a                             "Enable scrolling & resizing
set shiftwidth=4                        "Spaces per tab (when shifting)
set tabstop=4                           "Spaces per tab (when tabbing)
set expandtab                           "Make Tabs spaces
set smarttab                            "Indent sensitive tabbing
set t_Co=256                            "256-colour terminal
set errorbells                          "Incentive not to make any mistakes
set fillchars+=vert:¬                   "Fill characters for vert split border

let g:rainbow_active = 1

" Startify
let g:startify_session_dir = '~/.vim/session'
let g:startify_files_number = 6
let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   Recent Files']   },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'commands',  'header': ['   Commands']       },
            \ ]
let g:startify_bookmarks = [
            \ {'6': '~/.zshrc'},
            \ {'7': '~/.bashrc'},
            \ {'8': '~/.vimrc'},
            \ {'9': '~/.config/nvim/init.vim'},
            \ ]
let g:startify_change_to_dir = 1
let g:startify_enable_special = 1
let g:startify_skiplist = [
           \ '^/tmp',
           \ '/project/.*/documentation',
           \ escape(fnamemodify($HOME, ':p'), '\') .'mysecret.txt',
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
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown',
                      \'ext': '.md'}]

"  Other Stuff
" File Encoding
setglobal termencoding=utf-8
scriptencoding utf-8
set encoding=utf-8
set fileformat=unix

" Set Vim Language
let LANG='en_GB'
set langmenu=en_GB
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim


" => Colors
" highlight Statement        ctermfg=2
" highlight Directory        ctermfg=4
" highlight Constant         ctermfg=12
" highlight Special          ctermfg=4
" highlight Identifier       ctermfg=6
" highlight String           ctermfg=12
" highlight Number           ctermfg=1
" highlight Function         ctermfg=1
" highlight htmlEndTag       ctermfg=114
" highlight xmlEndTag        ctermfg=114
 
