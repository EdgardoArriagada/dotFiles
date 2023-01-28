() (
  local onSetup="_dotfiles_setup_"
  local isMacOs=`[[ "$(uname -s)" = "Darwin" ]] && printf 1`

  ###### BEGIN CONFIGURATION ######
  local commonPrograms=(
    nvim
    tmux
  )

  local macOsPrograms=(
    hammerspoon
  )

  local linuxPrograms=()

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

  ## Link programs to dot files
  stow "${allPrograms[@]}"

  ## Run setup functions
  for program in "${allPrograms[@]}"; do
    local onSetupFunc="${onSetup}.${program}"

    if type ${onSetupFunc} > /dev/null
      then ${onSetupFunc}
    fi
  done
)


