"
" plugin-settings.vim
" plugin settings
"

" # Fugitive settings
" Workaround for patch mode not responding
augroup nvim_term
  au!
  au TermOpen * startinsert
  au TermClose * stopinsert
augroup END
" display git status
nmap <leader>gs :Gstatus<CR>
" git diff mode
nmap <leader>gd :Gdiff<CR>
" push commits
nmap <leader>gp :Git push<CR>

" # nord-vim settings
" set colorscheme
colorscheme nord

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
let g:lightline = {
\   'colorscheme': 'nord',
\}

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

" # coc settings
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <C-n>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
" confirm complete
inoremap <silent><expr> <cr> pumvisible()
  \ ? coc#_select_confirm()
  \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" default extensions
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-neosnippet',
  \ 'coc-phpls',
  \ 'coc-json',
  \ 'coc-css',
  \ 'coc-vetur',
  \ 'coc-html',
  \ 'coc-emmet',
  \ 'coc-tsserver'
\]

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
