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

" Enable True Color support for Alacritty
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif



call plug#begin() 

Plug 'https://github.com/lervag/vimtex.git'

call plug#end()
