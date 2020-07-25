"
" coc.vim
" coc.nvim-specific settings
"

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
  \ 'coc-eslint',
  \ 'coc-svelte',
  \ 'coc-html',
  \ 'coc-emmet',
  \ 'coc-tsserver',
  \ 'coc-flutter'
\]

" autofix linting for JS
autocmd FileType js,vue nnoremap <leader>ll :CocCommand eslint.executeAutofix<CR>
