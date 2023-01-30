export isMacOs=`[[ "$(uname -s)" = "Darwin" ]] && printf 1`

() (
  ###### BEGIN CONFIGURATION ######
  local commonPrograms=(
    fd
    git
    nvim
    tmux
    alacritty
    ideaVim
    tig
  )

  local macOsPrograms=(
    hammerspoon
    skhd
  )

  local linuxPrograms=(
    bspwm
    dunst
    gnome
    picom
    pinentry
    polybar
    redshift
    rofi
    sxhkd
  )
  ######## END CONFIGURATION ######


  ## Populate program list
  local allPrograms=("${commonPrograms[@]}")

  if (( isMacOs ))
    then allPrograms+=("${macOsPrograms[@]}")
    else allPrograms+=("${linuxPrograms[@]}")
  fi

  ## Run link programs and run setup functions
  for program in "${allPrograms[@]}"; do
    if [[ -d ${program}/home ]]; then
      print "Linking ${program}..."
      stow -d ${program} -t .. home
    fi

    local setupPath=${program}/${program}.setup.zsh

    if [[ -f ${setupPath} ]]; then
      print "Setup ${program}..."
      source ${setupPath}
    fi
  done
)


