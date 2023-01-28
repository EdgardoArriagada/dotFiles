if ! (( isMacOs ))
  then ln -s $(which fdfind) ~/.local/bin/fd
fi
