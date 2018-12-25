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

" # base16-vim settings
" set colorscheme
colorscheme base16-monokai

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

" # ALE settings
" set fixer trigger key
nmap <leader>ll :ALEFix<CR>
" set info trigger key
nmap <leader>li :ALEInfo<CR>
" configure linters
let g:ale_linters = {
\   'vue': ['vls', 'eslint'],
\}
" configure fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'php': ['phpcbf', 'php_cs_fixer'],
\}

" # lightline settings
" show statusline
set laststatus=2
" hide default statusline
set noshowmode

" # vim-multiple-cursors settings
" remap select all instance
let g:multi_cursor_select_all_key = '<leader>d'

" # vim-smooth-scroll settings
noremap <silent> <C-U> :call smooth_scroll#up(&scroll, 0, 4)<CR>
noremap <silent> <C-D> :call smooth_scroll#down(&scroll, 0, 4)<CR>
noremap <silent> <C-B> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <C-F> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" # IndentLine settings
" disabled by default
let g:indentLine_enabled = 0
noremap <leader>ii :IndentLinesToggle<CR>

" # vim-php-namespace settings
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

" # phpactor settings
" Include use statement
nmap <Leader>pu :call phpactor#UseAdd()<CR>
" Invoke the context menu
nmap <Leader>pm :call phpactor#ContextMenu()<CR>

" # neosnippet settings
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-K> <Plug>(neosnippet_expand_or_jump)
smap <C-K> <Plug>(neosnippet_expand_or_jump)
xmap <C-K> <Plug>(neosnippet_expand_target)
