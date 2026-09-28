#!/bin/bash -x

# setting
GIT_USER_NAME=makotortat
GIT_USER_EMAIL=makotortat@gmail.com

script_dir=$(cd "$(dirname "$0")" && pwd -P)

backup_path () {
  path=$1
  backup="${path}.bak.$(date +%Y%m%d%H%M%S)"
  index=1

  while [ -e "$backup" ] || [ -L "$backup" ]; do
    backup="${path}.bak.$(date +%Y%m%d%H%M%S).${index}"
    index=$((index + 1))
  done

  mv "$path" "$backup"
  echo "Backed up $path to $backup"
}

ensure_symlink () {
  src=$1
  dst=$2

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    backup_path "$dst"
  fi

  ln -s "$src" "$dst"
}

require_command () {
  command_name=$1
  install_hint=$2

  if command -v "$command_name" 1>/dev/null 2>&1; then
    return
  fi

  echo "Please install ${command_name}."
  if [ -n "$install_hint" ]; then
    echo "$install_hint"
  fi
  exit 1
}

require_one_command () {
  install_hint=$1
  shift

  for command_name in "$@"; do
    if command -v "$command_name" 1>/dev/null 2>&1; then
      return
    fi
  done

  echo "Please install one of: $*"
  if [ -n "$install_hint" ]; then
    echo "$install_hint"
  fi
  exit 1
}

make_link_dotfiles () {
  for file in $DOTFILES; do
    ensure_symlink "${script_dir}/${file}" "${HOME}/${file}"
  done
}

setting_zsh () {
  case "$SHELL" in
    *zsh) ;;
    *)
      cat /etc/shells
      echo This script supports only zsh. Please do chsh -s /usr/bin/zsh
      exit
      ;;
  esac
  DOTFILES=".zshrc .zshrc.pyenv"
  make_link_dotfiles
}

setting_neovim () {
  require_command nvim "ex) sudo apt install neovim"
  require_command make "ex) sudo apt install build-essential"
  require_command cc "ex) sudo apt install build-essential"
  require_one_command "ex) sudo apt install curl" curl wget go
  
  if [ -z "${XDG_CONFIG_HOME}" ];
  then
    export XDG_CONFIG_HOME="${HOME}/.config"
  fi

  DOTFILES=".vimrc"
  make_link_dotfiles

  mkdir -p "${HOME}/.vim"
  mkdir -p "${XDG_CONFIG_HOME}/nvim"
  ensure_symlink "${HOME}/.vimrc" "${XDG_CONFIG_HOME}/nvim/init.vim"
}

setting_tmux () {
  require_command tmux "ex) sudo apt install tmux"

  DOTFILES=".tmux.conf"
  make_link_dotfiles
}

setting_git () {
  require_command git "ex) sudo apt install git"

  DOTFILES=".git_commit_template"
  make_link_dotfiles
  git config --global commit.template ~/.git_commit_template
  git config --global user.name ${GIT_USER_NAME}
  git config --global user.email ${GIT_USER_EMAIL}
  # git config --global core.editor vi
}

install_dein () {
  dein_dir="${HOME}/.cache/dein/repos/github.com/Shougo/dein.vim"
  dein_parent=${dein_dir%/*}

  if [ -d "$dein_dir" ]; then
    return
  fi

  mkdir -p "$dein_parent"
  git clone https://github.com/Shougo/dein.vim "$dein_dir"
}

install_tpm () {
  if [ -d "${HOME}/.tmux/plugins/tpm" ]; then
    return
  fi

  mkdir -p "${HOME}/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  echo try install tmux plugins
  ~/.tmux/plugins/tpm/bin/install_plugins
}

setting_zsh
setting_neovim
setting_tmux
setting_git
install_dein
install_tpm

exit;
