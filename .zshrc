# REF : https://github.com/romkatv/powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# REF : https://github.com/zdharma-continuum/zinit
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zdharma-continuum/history-search-multi-word

# REF : https://github.com/romkatv/powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# alias
autoload -Uz compinit && compinit

# alias
if command -v nvim 1>/dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim'
  # export MANPAGER="col -b -x|nvim -R -c 'set ft=man nolist nomod noma' -"
  if ls /etc/redhat-release 1>/dev/null 2>&1; then
    export MANPAGER="/bin/sh -c \"col -b -x|nvim -R -c 'set ft=man nolist nonu noma' -\""
  fi
fi
alias ll="ls -l"
## REF : https://orebibou.com/ja/home/201805/20180503_001/
alias show_all_commands="whence -pm \"*\""

# OS dependencies
# REF : https://qiita.com/abetomo/items/3df53752edf2bd0855c9
case ${OSTYPE} in
    darwin*)
        alias ls='ls -G'
        # REF : https://qiita.com/okohs/items/adf36737973c4e2d0336
        export CLICOLOR=1
        export LSCOLORS="GxFxCxDxBxegedabagaced"
        alias brew='/usr/local/bin/brew'
        alias orgbrew='/opt/homebrew/bin/brew'
        ;;
    linux*)
        alias ls='ls --color'
        alias ls="ls -GF --color=auto"
        ;;
esac

# history
# REF : https://qiita.com/syui/items/c1a1567b2b76051f50c4
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000

setopt hist_ignore_dups
setopt EXTENDED_HISTORY

function history-all { history -E 1 }

# REF : https://stackoverflow.com/questions/32057760/is-it-possible-to-not-share-history-between-panes-windows-in-tmux-with-zsh
setopt noincappendhistory
setopt nosharehistory

# ssh
function show_ssh_pubkey {
 ssh -V
 for list in `ls /etc/ssh/*.pub`; do echo ssh-keygen -lf ${list} ;ssh-keygen -lf ${list} ; done
}

# env
export XDG_CONFIG_HOME=~/.config
if command -v nvim 1>/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# auto log
if ls ~/log 1>/dev/null 2>&1; then
else
  mkdir ~/log
fi
alias start_log='script -fqa ~/log/$(date +%Y%m%d_%H%M%S)_${HOST}_$(whoami)_${TITLE}.log'
case ${OSTYPE} in
    darwin*)
        alias start_log='script -Fqa ~/log/$(date +%Y%m%d_%H%M%S)_${HOST}_$(whoami)_${TITLE}.log'
        ;;
    linux*)
        alias start_log='script -fqa ~/log/$(date +%Y%m%d_%H%M%S)_${HOST}_$(whoami)_${TITLE}.log'
        ;;
esac
alias show_script_log='echo 0 10000 > ~/timelog_for_scriptlog.log; scriptreplay -t ~/timelog_for_scriptlog.log '

# restart shell
# REF : https://qiita.com/yusabana/items/c4de582c6f85a42817d8
alias relogin='exec $SHELL -l'

# keybind : ctrl + a
bindkey -e

# REF : https://qiita.com/awakia/items/1d5cd440ce58ef4fb8ae
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.zshrc.pyenv ] && source ~/.zshrc.pyenv

