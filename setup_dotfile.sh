#!/bin/bash -x

script_dir=$(cd $(dirname $0); pwd)

make_link_dotfiles () {
  for file in ${DOTFILES[@]}; do
    if [ -e "~/${file}" ];
    then
      :
    else
      ln -s ${script_dir}/${file} ~/${file}
    fi
  done
}

setting_zsh () {
  echo $SHELL | grep "zsh"
  if [ $? -eq 0 ];
  then
    :
  else
    cat /etc/shells;
    echo This script supports only zsh. ; exit;
  fi
  DOTFILES=( .zshrc .zshrc.pyenv )
  make_link_dotfiles
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
  make_link_dotfiles
}

setting_tmux () {
  if command -v tmux 1>/dev/null 2>&1; then
    :
  else
    echo "Please install tmux." ; exit;
  fi

  DOTFILES=( .tmux.conf )
  make_link_dotfiles
}

install_dein () {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)"
  # curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
  # For example, we just use `~/.cache/dein` as installation directory
  # sh ./installer.sh ~/.cache/dein
}

install_tpm () {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

setting_zsh
setting_neovim
setting_tmux
install_dein
install_tpm

exit;

