"
" plugins.vim
" plugins powered by vim-plug
"

" Load vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent call system('mkdir -p ~/.vim/autoload')
  silent call system('curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  execute 'source  ~/.vim/autoload/plug.vim'
  augroup plugsetup
    au!
    autocmd VimEnter * PlugInstall
  augroup end
endif

call plug#begin('~/.vim/plugged')


" # git stuff
" git commands
Plug 'tpope/vim-fugitive'
" git change indicator
Plug 'airblade/vim-gitgutter'


" # features
" file tree pane
Plug 'scrooloose/nerdtree'
" better terminal integration
Plug 'wincent/terminus'
" statusbar
Plug 'itchyny/lightline.vim'
" multiple cursor selection
Plug 'terryma/vim-multiple-cursors'
" indent lines
Plug 'Yggdroot/indentLine'

" fuzzy file finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" autocompletion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " js autocompletion
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  " php autocompletion
  Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'


" # programming
" powerful commenter
Plug 'scrooloose/nerdcommenter'
" align blocks of text
Plug 'godlygeek/tabular'
" syntax checker
Plug 'w0rp/ale'
" replace surrounding quotes/parenthesis 
Plug 'tpope/vim-surround'
" auto insert quotes/parenthesis
Plug 'jiangmiao/auto-pairs'

" # language-specific
" color previewer for css
Plug 'gorodinskiy/vim-coloresque'
" improved js indent and syntax highlighting
Plug 'pangloss/vim-javascript'
" html5 omnicomplete and syntax
Plug 'othree/html5.vim'
" emmet
Plug 'mattn/emmet-vim'
" vue syntax highlighting
Plug 'posva/vim-vue'
" php auto-import classes
Plug 'arnaud-lb/vim-php-namespace'

call plug#end()