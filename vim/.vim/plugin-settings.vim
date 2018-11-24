"
" plugin-settings.vim
" plugin settings
"

" # Emmet settings
" expand with tab
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" # NERDTree settings
" right arrow to open node
let NERDTreeMapActivateNode = '<right>'
" display hidden files
let NERDTreeShowHidden = 1
" toggle display of tree with <Leader> + n
nmap <leader>n :NERDTreeToggle<CR>
" locate the focused file in tree with <Leader> + j
nmap <leader>j :NERDTreeFind<CR>
" ignore these files in tree
let NERDTreeIgnore=['\.DS_Store', '\~$', '\.swp']

" # fzf settings
" set fzf trigger key
noremap <leader>t :FZF<CR>
" set the_silver_searcher trigger key
" requires the_silver_searcher to be installed:
" brew install the_silver_searcher
noremap <leader>f :Ag<CR>

" # vim-easy-align settings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" # lightline settings
" show statusline
set laststatus=2
" hide default statusline
set noshowmode

" # vim-multiple-cursors settings
" remap select all instance
let g:multi_cursor_select_all_key = '<leader>d'

" # IndentLine settings
" toggle indent lines
nnoremap <C-I> :IndentLinesToggle<CR>
" disabled by default
let g:indentLine_enabled = 0

" # vim-php-namespace settings
" auto-insert use class
function! IPhpInsertUse()
    call PhpInsertUse()
    call PhpSortUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>pu <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>pu :call PhpInsertUse()<CR>
" sort imported classes
autocmd FileType php inoremap <Leader>ps <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>ps :call PhpSortUse()<CR>

" # deoplete settings
" enable autocomplete on startup
" requires neovim python client to be installed:
" pip3 install neovim
let g:deoplete#enable_at_startup = 1

" # deoplete-ternjs settings
" enable ternjs in other file formats
" disabled as it crashes with vue files
"let g:deoplete#sources#ternjs#filetypes = ['vue']

" # phpcd settings
" deoplete integration
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']
" set autoload default path
let g:phpcd_autoload_path = '.autoload.php'

" # neosnippet settings
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
