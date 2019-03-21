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
imap jk <esc>

" # netrw configs
" Hide banner
let g:netrw_banner = 0
" Set tree view as default
let g:netrw_liststyle = 3
" toggle display of tree with <Leader> + n
noremap <leader>n :vsplit .<CR>
" locate the focused file in tree with <Leader> + j
noremap <leader>j :vsplit<CR>:Explore<CR>

" # Backups
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" security
set modelines=1

" Start scrolling when 8 lines away from bottom
set scrolloff=8

" Open new split panes to right and bottom
set splitbelow
set splitright

" no arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" " turn up a notch by disabling vimarrows
" noremap h <NOP>
" noremap j <NOP>
" noremap k <NOP>
" noremap l <NOP>

" remap pane switching
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" tab shortcuts
nnoremap <C-T> :tabnew<CR>
nnoremap <C-X> :tabclose<CR>

" edit/source vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" J to join lines, K to split lines
nnoremap K i<CR><esc>

" clear highlight
nnoremap <esc> :noh<CR><esc>

" reload file changed outside vim
set autoread

" # save/load session
nnoremap <leader>s :mksession! ~/.vimsession.vim<CR>
nnoremap <leader>o :source ~/.vimsession.vim<CR>

" save/close buffer
nnoremap <C-Q> :q<CR>
nnoremap <C-S> :w<CR>
inoremap <C-S> <C-O>:w<CR>
