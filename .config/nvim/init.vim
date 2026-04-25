set encoding=utf-8
set termguicolors
set number relativenumber

nmap <localleader>c <Plug>(vimtex-compile)

let g:tex_flavor='latex'
let g:vimtex_view_method='sioyek'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal="abdmg"
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_complete_enabled = 0
set rtp+=/usr/local/opt/fzf
let g:fzf_vim = {}
let g:fzf_vim.preview_window = []

nnoremap <D-z> u
nnoremap <D-s-z> <C-r>
inoremap <D-z> <C-o>u
inoremap <D-S-z> <C-o><C-r>
vnoremap <D-z> <Esc>u
vnoremap <D-S-z> <Esc><C-r>

nnoremap <D-w> :bd<CR>
nnoremap <C-w> :bd<CR>

nnoremap <D-a> ggVG
nnoremap <C-a> ggVG

nnoremap <D-s> :w<CR>
inoremap <D-s> <Esc>:w<CR>a
vnoremap <D-s> <Esc>:w<CR>

nmap <A-j> <Plug>MoveLineDown
nmap <A-k> <Plug>MoveLineUp
vmap <A-j> <Plug>MoveBlockDown
vmap <A-k> <Plug>MoveBlockUp

" Dupliquer avec Alt+Shift+j/k
nnoremap <A-S-j> :t.<CR>
nnoremap <A-S-k> :t.-1<CR>
vnoremap <A-S-j> :t'><CR>gv
vnoremap <A-S-k> :t'<-1<CR>gv

command! ReloadSnippets call UltiSnips#RefreshSnippets()


" --- Custom LaTeX highlights (TreeSitter) ---
set termguicolors

lua << EOF
-- On vérifie si Treesitter est présent avant de configurer
local status, ts = pcall(require, "nvim-treesitter.configs")
if status then
    ts.setup {
        highlight = { 
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end

-- On applique tes couleurs vibrantes (Overrides)
-- Celles-ci fonctionneront même si le setup ci-dessus attend un redémarrage
local hl = vim.api.nvim_set_hl
hl(0, "@function.macro.latex", { fg = "#FABD2F", bold = true }) -- Gold
hl(0, "@punctuation.special.latex", { fg = "#FE8019" })         -- Orange
hl(0, "@variable.parameter.latex", { fg = "#83A598" })         -- Bleu
hl(0, "@math.symbol.latex", { fg = "#FB4934" })                -- Rose/Rouge
hl(0, "@label.latex", { fg = "#B8BB26" })                      -- Vert
EOF

"Fix tab size
set tabstop=4
set shiftwidth=4
set expandtab

"C'est le python pour pour UltiSnips
let g:python3_host_prog = '~/.neovim-venv/bin/python'

"Ajout des plugins 
call plug#begin()

Plug 'https://github.com/lervag/vimtex'
Plug 'https://github.com/SirVer/ultisnips'
Plug 'https://github.com/tpope/vim-dispatch'
Plug 'https://github.com/machakann/vim-sandwich'
Plug 'psliwka/vim-smoothie'
Plug 'https://github.com/xiyaowong/transparent.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://github.com/KeitaNakamura/tex-conceal.vim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'matze/vim-move'

call plug#end()

"Configuration UltiSnips 
let g:UltiSnipsExpandTrigger       = '<Tab>'   
let g:UltiSnipsJumpForwardTrigger  = '<Tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

"Pour les snippets
let g:UltiSnipsSnippetDirectories=[$HOME.'/.config/nvim/UltiSnips']


"Smooth scroll
nnoremap <unique> <C-D> <cmd>call smoothie#do("\<C-D>") <CR>
vnoremap <unique> <C-D> <cmd>call smoothie#do("\<C-D>") <CR>

" --- Custom LaTeX highlights to match your screenshot ---
lua << EOF
local highlights = {
    ["@function.macro.latex"] = { fg = "#fabd2f" }, -- Gold for \begin, \frac, etc.
    ["@punctuation.special.latex"] = { fg = "#fe8019" }, -- Orange for { }
    ["@string.latex"] = { fg = "#83a598" },         -- Blue for content in brackets
    ["@variable.parameter.latex"] = { fg = "#83a598" }, -- Also blue for {arguments}
    ["@math.symbol.latex"] = { fg = "#fb4934" },    -- Red/Pink for \gamma, \nu, \rho
    ["@label.latex"] = { fg = "#79dac8" },          -- Aqua/Blue for labels
}

for group, settings in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, settings)
end
EOF

lua << EOF
-- Configuration de texlab avec vim.lsp.config
vim.lsp.config.texlab = {
  cmd = { 'texlab' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { '.latexmkrc', '.git' },
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = {"-pdf", "-interaction=nonstopmode", "-synctex=1", "%f"},
        onSave = true,
      },
      forwardSearch = {
        executable = "sioyek",
        args = {
          "--reuse-window",
          "--forward-search-file", "%f",
          "--forward-search-line", "%l",
          "%p"
        },
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = true,
      },
    }
  },
}

-- Activer texlab automatiquement pour les fichiers .tex
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'plaintex', 'bib' },
  callback = function()
    vim.lsp.enable('texlab')
  end,
})

-- Keybindings LSP
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

-- Configuration nvim-cmp
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
EOF

set signcolumn=yes
lua vim.diagnostic.config({ virtual_text = true, signs = true })
