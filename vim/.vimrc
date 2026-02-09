syntax on
highlight LineNr ctermfg=DarkGrey

:set number
set title
:set mouse=a
set laststatus=2

:augroup numbertoggle
: autocmd!
: autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu | endif
: autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set nornu | endif

hi CursorLineNr ctermfg=yellow guifg=Yellow
hi CursorLine cterm=NONE ctermbg=234 guibg=#1c1c1c

