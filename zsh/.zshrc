#===================================
#      EXPORTS & ENVIRONMENT
#===================================
#export OLLAMA_HOST="10.8.8.77:11434"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export EDITOR=vim

# add custom binaries to PATH
export PATH="/opt/homebrew/bin:$HOME/.local/bin:$PATH"
#export PATH="$HOME/.local/bin:$PATH"


#===================================
#      SHELL PLUGINS & TOOLS
#===================================
# Homebrew prefix (cached for speed)
BREW_PREFIX=$(brew --prefix)

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# fzf config 
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi 

# setup fzf keybindings and fuzzy completion
source <(fzf --zsh)

# zsh plugins autocomplete &N suggestions
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


#===================================
#             ALIASES
#===================================

# -- navigation -- 
alias y="yazi"
alias cl="clear"

# -- listing & files --
alias ls="eza"
alias ll="eza -lh --git --no-permissions --no-user --group-directories-first --sort Extension --time-style relative  -w 3 --icons=always" 
alias la="eza -lha --git --no-permissions --no-user --group-directories-first --sort Extension --time-style relative --icons=always" 
alias tree="eza -T -L 3" 

# -- git -- 
alias gst="git status"
alias git-list="find . -name ".git" -type d -prune"

# -- config & editor quick access -- 
alias zshrc="vim ~/.zshrc"
alias src="source ~/.zshrc"
alias vs="code"

# -- LaTeX -- 
alias tommypackage="vim /Users/tommy/Library/texmf/tex/latex/TommyPackage/TommyPackage.sty"
alias hsnips="vim Library/Application\ Support/Code/User/globalStorage/draivin.hsnips/hsnips/latex.hsnips"

# -- system & utils -- 
alias clip="pbcopy"
alias paste="pbpaste"
alias run="uv run"
alias nuke="kill -9"

# -- AI & LLM -- 
alias ask="ollama run"
alias deepseek='llama-cli --hf-repo Triangle104/DeepSeek-R1-Distill-Qwen-14B-Q4_K_M-GGUF --hf-file deepseek-r1-distill-qwen-14b-q4_k_m.gguf -cnv'
alias dsr1="mlx_lm.chat --model ~/llm/DeepSeek-R1 --max-tokens 8192"
alias nemo="mlx_lm.chat --model ~/llm/Mistral-Nemo --max-tokens 8192"
alias qwen="mlx_lm.chat --model ~/llm/Qwen --max-tokens 8192"
alias llama3="mlx_lm.chat --model ~/llm/llama3 --max-tokens 8192"
alias aichat-config="vim /Users/tommy/Library/Application\ Support/aichat/config.yaml"


clear

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tommy/.lmstudio/bin"
# End of LM Studio CLI section

