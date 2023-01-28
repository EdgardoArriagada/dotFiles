() (
  local onSetup="_dotfiles_setup_"
  local isMacOs=`[[ "$(uname -s)" = "Darwin" ]] && printf 1`

  ###### BEGIN CONFIGURATION ######
  local commonPrograms=(
    nvim
    tmux
    alacritty
  )

  local macOsPrograms=(
    hammerspoon
  )

  local linuxPrograms=(bspwm)

  ${onSetup}.tmux() {
    if (( isMacOs ))
      then sed -i '.bak' '1s/^/[[ -z "$TMUX" ]] \&\& tmux new -A -s main\'$'\n/g' ~/.zshrc
      else sed -i '1i[[ -z "$TMUX" ]] \&\& tmux new -A -s main' ~/.zshrc
    fi
  }

  ######## END CONFIGURATION ######


  ## Populate program list
  local allPrograms=("${commonPrograms[@]}")

  if (( isMacOs ))
    then allPrograms+=("${macOsPrograms[@]}")
    else allPrograms+=("${linuxPrograms[@]}")
  fi

  ## Run link programs and run setup functions
  for program in "${allPrograms[@]}"; do
    if [[ -d ${program} ]]; then
      print "Linking ${program}..."
      stow ${program}
    fi

    local onSetupFunc="${onSetup}.${program}"

    if type ${onSetupFunc} > /dev/null; then
      print "Setup ${program}..."
      ${onSetupFunc}
    fi
  done
)


