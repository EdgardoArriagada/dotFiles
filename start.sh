if [[ "$(uname -s)" = "Darwin" ]]; then
  # on MacOs
  stow hammerspoon nvim
else
  # on Linux
  stow nvim
fi
