alias ls="eza"
alias ll="eza -lh --git --no-permissions --no-user --group-directories-first --sort Extension --time-style relative --git-ignore -w 3 --icons=always" 
alias la="eza -lha --git --no-permissions --no-user --group-directories-first --sort Extension --time-style relative --icons=always" 
alias run="uv run"
alias zshrc="vim ~/.zshrc"
alias src="source ~/.zshrc"
alias tree="eza -T -L 3" 
alias fzf="fzf --highlight-line"
alias git-list="find . -name ".git" -type d -prune"
alias vs="code"
alias cl="clear"
alias stat="git status"
alias ask="ollama run"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="$HOME/.local/bin:$PATH"

export OLLAMA_HOST="10.8.8.77:11434"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"
clear
