set encoding=utf-8
set termguicolors
set number relativenumber
set spelllang=fr,en_us
set spell
set numberwidth=1
set signcolumn=yes
set laststatus=0
set cmdheight=0
set noshowmode
set conceallevel=2
set tabstop=4
set shiftwidth=4
set expandtab
set clipboard=unnamedplus

" ========== Configuration VimTeX ==========
let g:tex_flavor='latex'
let g:vimtex_view_method='sioyek'
let g:vimtex_quickfix_mode=0
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_compiler_method='latexmk'
let g:vimtex_complete_enabled=0
let g:vimtex_view_automatic=0
let g:vimtex_echo_ignore_wait=1
let g:vimtex_compiler_silent=1
let g:tex_conceal="abdmg"

let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : 'build',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options' : [
    \   '-pdf',
    \   '-interaction=nonstopmode',
    \   '-synctex=1',
    \   '-file-line-error',
    \   '-shell-escape',
    \   '-auxdir=output',
    \   '-emulate-aux-dir',
    \ ],
    \}



let g:vimtex_compiler_latexmk_engine='pdflatex'
let g:vimtex_view_use_temp_files=0
let g:vimtex_view_sioyek_options='--reuse-window --inverse-search "nvim --headless -c \"VimtexInverseSearch %2 ''%1''\""'

" Auto-compilation à la sauvegarde
 autocmd BufRead,BufNewFile *.tex silent! call timer_start(100, {-> execute('VimtexCompile')})



" ========== Highlights ==========
highlight texStatement guifg=#89b4fa gui=italic
highlight texArg       guifg=#f9e2af
highlight texMathZoneX guifg=#f2cdcd
highlight Normal       guibg=#15171c

" ========== FZF ==========
set rtp+=/usr/local/opt/fzf
let g:fzf_vim = {}
let g:fzf_vim.preview_window = []

" ========== UltiSnips ==========
let g:python3_host_prog='~/.neovim-venv/bin/python'
let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']
command! ReloadSnippets call UltiSnips#RefreshSnippets()

" ========== Keybindings ==========
" Undo/Redo
nnoremap <D-z> u
nnoremap <D-S-z> <C-r>
inoremap <D-z> <C-o>u
inoremap <D-S-z> <C-o><C-r>
vnoremap <D-z> <Esc>u
vnoremap <D-S-z> <Esc><C-r>

" Close buffer
nnoremap <D-w> :bd<CR>
nnoremap <C-w> :bd<CR>

" Select all
nnoremap <D-a> ggVG
nnoremap <C-a> ggVG

" Save
nnoremap <D-s> :w<CR>
inoremap <D-s> <Esc>:w<CR>a
vnoremap <D-s> <Esc>:w<CR>

" Move lines
nmap <A-j> <Plug>MoveLineDown
nmap <A-k> <Plug>MoveLineUp
vmap <A-j> <Plug>MoveBlockDown
vmap <A-k> <Plug>MoveBlockUp

" Duplicate lines
nnoremap <A-S-j> :t.<CR>
nnoremap <A-S-k> :t.-1<CR>
vnoremap <A-S-j> :t'><CR>gv
vnoremap <A-S-k> :t'<-1<CR>gv

" VimTeX
nmap <localleader>c <Plug>(vimtex-compile)
nmap <A-J> <plug>(vimtex-view)
imap <A-J> <esc><plug>(vimtex-view)a

" VimTeX - ouvrir PDF sans voler le focus
nmap <A-J> :call OpenPDFNoFocus()<CR>
imap <A-J> <esc>:call OpenPDFNoFocus()<CR>a

function! OpenPDFNoFocus()
    " Ouvrir le PDF
    call vimtex#view#view()
    " Refocus Alacritty immédiatement
    call timer_start(150, {-> system('open -a Alacritty')})
endfunction 

" Comment
nmap <A-/> gcc
vmap <A-/> gc

" Spell fix
inoremap <D-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Smooth scroll
nnoremap <unique> <C-D> <cmd>call smoothie#do("\<C-D>")<CR>
vnoremap <unique> <C-D> <cmd>call smoothie#do("\<C-D>")<CR>

" ========== Plugins ==========
call plug#begin()
Plug 'lervag/vimtex'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-dispatch'
Plug 'machakann/vim-sandwich'
Plug 'psliwka/vim-smoothie'
Plug 'xiyaowong/transparent.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'matze/vim-move'
Plug 'folke/tokyonight.nvim'
Plug 'dylanaraps/wal'
Plug 'sphamba/smear-cursor.nvim'
Plug 'epwalsh/obsidian.nvim'
call plug#end()

" ========== smear_cursor =======
lua require('smear_cursor').enabled = true

lua require('smear_cursor').setup({
    \cursor_color = '#d3cdc3',
    \stiffness = 0.8,
    \trailing_stiffness = 0.5,
    \distance_stop_animating = 0.5,
\})

" ========== Colorscheme ==========
let g:tokyonight_style="night"
colorscheme tokyonight

" ========== Lua Configuration ==========
lua << EOF
-- TreeSitter
local status, ts = pcall(require, "nvim-treesitter.configs")
if status then
    ts.setup {
        highlight = { 
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end

-- Highlights LaTeX
local hl = vim.api.nvim_set_hl
hl(0, "@function.macro.latex", { fg = "#FABD2F", bold = true })
hl(0, "@punctuation.special.latex", { fg = "#FE8019" })
hl(0, "@variable.parameter.latex", { fg = "#83A598" })
hl(0, "@math.symbol.latex", { fg = "#FB4934" })
hl(0, "@label.latex", { fg = "#B8BB26" })

-- LSP texlab
vim.lsp.config.texlab = {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.latexmkrc', '.git' },
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = {"-pdf", "-interaction=nonstopmode", "-synctex=1", "-auxdir=output", "-outdir=build", "%f"},
        onSave = false,
      },
      forwardSearch = {
        executable = "sioyek",
        args = {
          "--reuse-window",
          "--forward-search-file", "%f",
          "--forward-search-line", "%l",
          "build/%p"
        },
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true,
      },
    }
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'plaintex', 'bib' },
  callback = function()
    vim.lsp.enable('texlab')
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
})

vim.diagnostic.config({ virtual_text = true, signs = true })
EOF

" ========== Theme colors ==========
augroup CustomLatexColors
    autocmd!
    autocmd ColorScheme * highlight Normal guibg=#15171c guifg=#dcdcdc
    autocmd ColorScheme * highlight texStatement guifg=#8be9fd gui=italic
    autocmd ColorScheme * highlight texOptArgs guifg=#f1fa8c
    autocmd ColorScheme * highlight texArg guifg=#f1fa8c
    autocmd ColorScheme * highlight texBeginEndName guifg=#8be9fd gui=bold
    autocmd ColorScheme * highlight LineNr guifg=#6272a4
augroup END

" ============ inkscape figures =============== gilles castel



" Créer une figure (Mode Insertion)
" Prend le texte sur la ligne courante comme nom de fichier
inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>

" Éditer une figure (Mode Normal)
" Ouvre le fuzzy finder (rofi/dmenu/fzf selon votre installation) pour choisir la figure
nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
