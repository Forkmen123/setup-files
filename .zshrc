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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/.local/bin:$PATH"
export OLLAMA_HOST="10.8.8.77:11434"
clear
