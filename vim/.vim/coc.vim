"
" coc.vim
" coc.nvim-specific settings
"

" :CocList shortcut
nnoremap <leader>cc :CocList<CR>

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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nmap <silent> gK :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
