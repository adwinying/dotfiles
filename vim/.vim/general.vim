"
" general.vim
" General Vim settings
" Inspired by Doug Black
" https://dougblack.io/words/a-good-vimrc.html
"

" use vim settings, rather than vi settings
" must be first, because it changes other options as a side effect
set nocompatible

" # Color
colorscheme molokai
syntax enable

" # Spaces & Tabs (default to 2 spaces)
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" # language specific indentation
augroup configgroup
  autocmd!
  autocmd Filetype php setlocal ts=4 sw=4 sts=4 expandtab
augroup END

" # Leader Shortcuts
let mapleader=","
inoremap jk <esc>
iunmap <esc>

" # Backups
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup


" security
set modelines=1

" remap pane switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" tab shortcuts
nnoremap <C-T> :tabnew<CR>
nnoremap <C-X> :tabclose<CR>

" split vertically and switch to new pane
nnoremap <leader>vv :vsp<CR><C-W><C-L>

" edit/source vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" : key alternative
nnoremap ; :

" # save/load session
nnoremap <leader>s :mksession! ~/.vimsession.vim<CR>
nnoremap <leader>o :source ~/.vimsession.vim<CR>

" save/close buffer
nnoremap <C-Q> :q<CR>
nnoremap <C-S> :w<CR>
