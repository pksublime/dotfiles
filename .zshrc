#################################
# ZSH Configuration File
#################################

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

case $(hostname) in
        build01)
		plugins=(fzf git colored-man-pages colorize pip python brew macos zsh-autosuggestions zsh-syntax-highlighting)
                ;;
        patricks_macbook)
		plugins=(notify fzf git colored-man-pages colorize pip python brew macos zsh-autosuggestions zsh-syntax-highlighting)
		FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
                ;;
esac
source <(fzf --zsh)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias clint='run-clang-format.py -r .'
alias format='git config --file .gitmodules --get-regexp path | cut -d " " -f2 | xargs -I {}  find . -path ./{} -prune -o -name "*.cpp" -o -name "*.c" -o -name "*.h" -o -name "*.ino" | xargs -I {} clang-format --style=file -i {}'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

mkcdir ()
{
  mkdir -p -- "$1" && cd -P -- "$1"
}
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Escape square brackets by default
unsetopt nomatch
#export
export PATH="/usr/local/opt/ruby@3.0/bin:/usr/local/lib/ruby/gems/3.0.0/bin:$PATH"
export PATH="/usr/local/opt/llvm@16/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="~/.local/bin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
# export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_2.0.600.202301161003/tools/bin/:$PATH"
# export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_2.1.0.20305091550/tools/bin/:$PATH"
# export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_2.1.100.202311100844/tools/bin/:$PATH"
# export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_2.1.200.202311302303/tools/bin/:$PATH"
# export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_2.1.201.202404072231/tools/bin/:$PATH"
export PATH="/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/:$PATH"

# add ST's custom openocd
export PATH="/Applications/STMicroelectronics/ST_OpenOCD/bin:$PATH"

#
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="/usr/local/opt/avr-gcc@10/bin:$PATH"
export PATH="/Applications/ArmGNUToolchain/13.3.Rel1/arm-none-eabi/bin:$PATH"

# 1Password items
case $(hostname) in
        build01)
                ;;
        patricks_macbook)
		source ~/.config/op/plugins.sh
                ;;
esac
alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale

export STM32_PRG_PATH=/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin

autoload -U compinit
compinit -i

# Keep near end
source $ZSH/oh-my-zsh.sh

# zsh-notify settings
zstyle ':notify:*' error-sound "Glass"
zstyle ':notify:*' success-sound "default"
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' expire-time 2500
zstyle ':notify:*' blacklist-regex 'find|git'
zstyle ':notify:*' error-icon "https://media3.giphy.com/media/10ECejNtM1GyRy/200_s.gif"
zstyle ':notify:*' error-title "wow such #fail"
zstyle ':notify:*' success-icon "https://s-media-cache-ak0.pinimg.com/564x/b5/5a/18/b55a1805f5650495a74202279036ecd2.jpg"
zstyle ':notify:*' success-title "very #success. wow"

. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile"
export HOMEBREW_NO_AUTO_UPDATE=1
TZ='America/Chicago'; export TZ

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ "$OSTYPE" == "darwin"* ]]; then
    export GIT_EDITOR="code --wait"
else
    export GIT_EDITOR="vim"
fi


