" let mapleader=","
let mapleader=" "
noremap : ;
noremap ; :
inoremap kj <Esc>
" nnoremap <Space> :w<Cr>
nnoremap <Leader>s :w<Cr>
nnoremap tk ;tabprev<Cr>
nnoremap tj ;tabnext<Cr>
nnoremap <Leader>yy _yg_
vnoremap y ygv<Esc>
set clipboard=unnamed,unnamedplus
set number relativenumber
set wrap
set linebreak
set autochdir
set ignorecase
set smartcase

set noshowmode
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

"For Vimiwki"
set nocompatible
syntax on
filetype plugin on
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]
nnoremap <leader><Space> :VimwikiToggleListItem<Cr>
vnoremap <leader><Space> :VimwikiToggleListItem<Cr>

" For Lightline
set laststatus=2
let g:lightline = {'colorscheme': 'wombat'}

" PLUGINS "
call plug#begin()
Plug 'tpope/vim-surround'
Plug 'https://github.com/joshdick/onedark.vim.git'
Plug 'itchyny/lightline.vim'
Plug 'vimwiki/vimwiki'
call plug#end()

" MY COLOR SCHEME "
colorscheme onedark
