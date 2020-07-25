"
" plugin-settings.vim
" plugin settings
"

" # Fugitive settings
" Workaround for patch mode not responding
if has('nvim')
  augroup nvim_term
    au!
    au TermOpen * startinsert
    au TermClose * stopinsert
endif
augroup END
" display git status
nmap <leader>gs :Gstatus<CR>
" push commits
nmap <leader>gp :Git push<CR>
" git diff mode
nmap <leader>gdd :Gdiff<CR>
" git diff mode (against master)
nmap <leader>gdm :Gdiff master<CR>
" launch difftool (against master)
nmap <leader>gdt :Git difftool --name-status master<CR>

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
nnoremap <leader>ll :ALEFix<CR>
" set info trigger key
nnoremap <leader>li :ALEInfo<CR>
" configure linter aliases
let g:ale_linter_aliases = {
\   'svelte': ['css', 'javascript'],
\}
" configure linters
let g:ale_linters = {
\   'vue': ['vls', 'eslint'],
\   'svelte': ['eslint'],
\}
" configure fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'svelte': ['eslint'],
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

" # vim-smooth-scroll settings
noremap <silent> <C-U> :call smooth_scroll#up(&scroll, 0, 4)<CR>
noremap <silent> <C-D> :call smooth_scroll#down(&scroll, 0, 4)<CR>
noremap <silent> <C-B> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <C-F> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" # flutter settings
" flutter lint command
autocmd FileType dart nnoremap <leader>ll :!flutter format %<CR>

" # coc settings
" :CocList shortcut
nnoremap <leader>cc :CocList<CR>
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
  \ 'coc-svelte',
  \ 'coc-html',
  \ 'coc-emmet',
  \ 'coc-tsserver',
  \ 'coc-flutter'
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
