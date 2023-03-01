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
noremap <leader>ff :FZF<CR>
" set the_silver_searcher trigger key
" requires the_silver_searcher to be installed:
" brew install the_silver_searcher
noremap <leader>fz :Ag<CR>

" # vim-easy-align settings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" # lightline settings
" hide default statusline
set noshowmode
" set lightline theme
let g:lightline = { 'colorscheme': 'nord' }

" # vim-smooth-scroll settings
noremap <silent> <C-U> :call smooth_scroll#up(&scroll, 0, 4)<CR>
noremap <silent> <C-D> :call smooth_scroll#down(&scroll, 0, 4)<CR>
noremap <silent> <C-B> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <C-F> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
