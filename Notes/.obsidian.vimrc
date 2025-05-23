" let mapleader=","
" let mapleader=" "
noremap : ;
noremap ; :
inoremap kj <Esc>

nmap j gj
nmap k gk

nnoremap <Leader>s :w<Cr>
nnoremap tk ;tabprev<Cr>
nnoremap tj ;tabnext<Cr>
nnoremap <Leader>yy _yg_
nnoremap Q @q
" nnoremap <CR> ;noh<CR>
nnoremap <leader>- 50%
nnoremap <leader>a ggVG
nnoremap <leader>; v<Esc>A;<Esc>gv<Esc>
nnoremap <leader>, v<Esc>A,<Esc>gv<Esc>

vnoremap y ygv<Esc>
nnoremap <Leader>( <Esc>[(v%o
vnoremap ( <Esc>[(v%o
nnoremap <Leader>{ <Esc>[{v%o
vnoremap { <Esc>[{v%o

unmap <Space>
exmap closeOthers obcommand workspace:close-others
nnoremap <Space>xo :closeOthers

" Seems obsidian saves files automatically
" exmap saveFile obcommand editor:save-file
" nnoremap <Space>s :saveFile

exmap x obcommand workspace:close
exmap xal obcommand workspace:close-tab-group
exmap xall obcommand workspace:close-tab-group

nnoremap <Up> <C-u>
nnoremap <Down> <C-d>
vnoremap <Up> <C-u>
vnoremap <Down> <C-d>

set clipboard=unnamed
