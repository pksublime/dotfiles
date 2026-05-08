#################################
# ZSH Configuration File
#################################

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# oh-my-zsh options
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=7
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins — base set, extended by OS/hostname files below
GENERAL_PLUGINS=(fzf git colored-man-pages colorize pip python zsh-autosuggestions zsh-syntax-highlighting zsh-make-completion)
plugins=("${GENERAL_PLUGINS[@]}")

# Source OS-specific config
# Note: these files may modify plugins, fpath, and PATH — must happen before compinit
if [[ "$OSTYPE" == "darwin"* ]]; then
    [[ -f ~/.zshrc.darwin ]] && source ~/.zshrc.darwin
else
    [[ -f ~/.zshrc.linux ]] && source ~/.zshrc.linux
fi

# Source machine-specific config
[[ -f ~/.zshrc.$(hostname) ]] && source ~/.zshrc.$(hostname)

source <(fzf --zsh)

# Universal PATH
export PATH="$HOME/.local/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

# Aliases
alias clint='run-clang-format.py -r .'
alias format='git config --file .gitmodules --get-regexp path | cut -d " " -f2 | xargs -I {}  find . -path ./{} -prune -o -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.ino" | xargs -I {} clang-format --style=file -i {}'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias suz='sudo HOME=$HOME ZDOTDIR=$HOME ZSH_DISABLE_COMPFIX=true zsh'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

rgf () {
    rg --files --hidden --glob '!.git' | fzf --preview 'bat --style=numbers --color=always --line-range :200 {}'
}

mkcdir () {
    mkdir -p -- "$1" && cd -P -- "$1"
}

# Escape square brackets by default
unsetopt nomatch

autoload -U compinit
compinit -i

# Keep near end
source $ZSH/oh-my-zsh.sh

# Atuin shell history
[[ -f "$HOME/.atuin/bin/env" ]] && . "$HOME/.atuin/bin/env"
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

export ENABLE_LSP_TOOLS=1
export GPG_TTY=$(tty)
export NEXT_TELEMETRY_DISABLED=1

[[ -f ~/.fvp.zsh ]] && source ~/.fvp.zsh

alias claude-mem='/Users/patricklittle/.bun/bin/bun "/Users/patricklittle/Library/Application Support/Claude/local-agent-mode-sessions/a88484c1-6ca2-47d4-bd4f-210ab6a26ba3/fb360c3f-4b23-4234-b458-68d619fb8f31/rpm/plugin_01XjS7dwPQvNdWemNpbFcPxA/scripts/worker-service.cjs"'
