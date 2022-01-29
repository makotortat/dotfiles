#!/bin/bash -x

script_dir=$(cd $(dirname $0); pwd)

setting_zsh () {
  echo $SHELL | grep "zsh"
  if [ $? -eq 0 ];
  then
    :
  else
    echo This script supports only zsh. ; exit;
  fi
  DOTFILES=( .zshrc .zshrc.pyenv .tmux.conf )
  for file in ${DOTFILES[@]}; do
    if [ -e "~/${file}" ];
    then
      :
    else
      ln -s ${script_dir}/${file} ~/${file}
    fi
  done
}

setting_neovim () {
  if command -v nvim 1>/dev/null 2>&1; then
    :
  else
    echo "Please install neovim." ; exit;
  fi
  
  if [ -z `echo $XDG_CONFIG_HOME` ];
  then
    mkdir -p ~/.config
    export XDG_CONFIG_HOME=~/.config
  fi
  mkdir ~/.vim
  ln -s ~/.vim ~/.config/nvim
  ln -s ~/.vimrc ~/.config/nvim/init.vim

  DOTFILES=( .vimrc )
  for file in ${DOTFILES[@]}; do
    if [ -e "~/${file}" ];
    then
      :
    else
      ln -s ${script_dir}/${file} ~/${file}
    fi
  done
}

install_dein () {
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  # For example, we just use `~/.cache/dein` as installation directory
  sh ./installer.sh ~/.cache/dein
}

setting_zsh
setting_neovim
install_dein

exit;

