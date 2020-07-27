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
  autocmd Filetype blade setlocal ts=2 sw=2 sts=2 expandtab
  autocmd Filetype php setlocal ts=4 sw=4 sts=4 expandtab
augroup END

" # Leader Shortcuts
let mapleader=","

" # netrw configs
" Hide banner
let g:netrw_banner = 0
" Set tree view as default
let g:netrw_liststyle = 3
" toggle display of tree with <Leader> + n
noremap <leader>n :vsplit .<CR>
" locate the focused file in tree with <Leader> + j
noremap <leader>j :vsplit<CR>:Explore<CR>

" # Markdown settings
" Enabled syntax highlight for code blocks
let g:markdown_fenced_languages = ['html', 'vue', 'javascript', 'js=javascript', 'css']

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

" tab shortcuts
nnoremap <C-T> :tabnew<CR>
nnoremap <C-X> :tabclose<CR>

" edit/source vimrc
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" J to join lines, K to split lines
nnoremap K i<CR><esc>

" Y to copy to clipboard
nnoremap Y "*y

" clear highlight
nnoremap <esc><esc> :noh<CR>

" remap K to gK
nnoremap gK K

" remap pane switching
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
execute "set <M-l>=\el"
execute "set <M-h>=\eh"
nnoremap <A-j> :resize +5
nnoremap <A-k> :resize -5
nnoremap <A-l> :vertical resize -5
nnoremap <A-h> :vertical resize +5

" save/load session
nnoremap <leader>s :mksession! ~/.vimsession.vim<CR>
nnoremap <leader>o :source ~/.vimsession.vim<CR>

" save/close buffer
nnoremap <C-Q> :q<CR>
nnoremap <C-S> :w<CR>
inoremap <C-S> <C-O>:w<CR>
