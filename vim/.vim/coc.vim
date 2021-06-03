"
" coc.vim
" coc.nvim-specific settings
"

" Load coc manually
nnoremap <leader>cl :call plug#load('coc.nvim') \| echom 'coc is now loaded!'<CR>

" Load coc configs when plugin is loaded
autocmd! User coc.nvim call LoadCocConfig()

function! LoadCocConfig() abort
  " :CocList shortcut
  nnoremap <leader>cc :CocList<CR>

  " confirm complete
  inoremap <silent><expr> <cr> pumvisible()
    \ ? coc#_select_confirm()
    \ : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " default extensions
  let g:coc_global_extensions = [
    \ 'coc-pairs',
    \ 'coc-snippets',
    \ 'coc-phpls',
    \ 'coc-json',
    \ 'coc-css',
    \ 'coc-vetur',
    \ 'coc-eslint',
    \ 'coc-svelte',
    \ 'coc-html',
    \ 'coc-emmet',
    \ 'coc-tailwindcss',
    \ 'coc-tsserver',
    \ 'coc-flutter',
    \ 'coc-go',
  \]

  " autofix linting for JS
  autocmd FileType javascript,typescript,vue,svelte nnoremap <silent><buffer><leader>ll :CocCommand eslint.executeAutofix<CR>
  " format buffer
  nnoremap <silent> <leader>ll :call CocActionAsync('format')<CR>

  " Use `[g` and `]g` to navigate diagnostics
  " Use `,cd` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)
  nmap <silent> <leader>cd :CocDiagnostics<CR>

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

  " # coc-snippets
  " Use <C-j> for jump to next placeholder, it's default of coc.nvim
  let g:coc_snippet_next = '<c-j>'
  " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
  let g:coc_snippet_prev = '<c-k>'
  " Use <C-j> for both expand and jump (make expand higher priority.)
  imap <C-j> <Plug>(coc-snippets-expand-jump)
endfunction
