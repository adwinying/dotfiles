"
" plugins.vim
" plugins powered by vim-plug
"

" Load vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')


" # git stuff
" git commands
Plug 'tpope/vim-fugitive'
" git change indicator
Plug 'airblade/vim-gitgutter'


" # features
" colors
Plug 'arcticicestudio/nord-vim'
" statusbar
Plug 'itchyny/lightline.vim'
" smooth scroll
Plug 'terryma/vim-smooth-scroll'
" advanced substitution
Plug 'tpope/vim-abolish'
" tmux integration
Plug 'christoomey/vim-tmux-navigator'
Plug 'melonmanchan/vim-tmux-resizer'
" fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


" # programming
" editorconfig
Plug 'editorconfig/editorconfig-vim'
" commenter
Plug 'tomtom/tcomment_vim'
" align blocks of text
Plug 'junegunn/vim-easy-align'
" replace surrounding quotes/parenthesis
Plug 'tpope/vim-surround'
" enable . support for plugins
Plug 'tpope/vim-repeat'


call plug#end()
