#!/usr/bin/env zsh
set -o errexit
set -o pipefail

zparseopts -D -E -F -- \
  s=skipSetup \
  || return 1

source ./config.zsh

export isMacOs=`[[ "$(uname -s)" = "Darwin" ]] && printf 1`

# Populate program list
local allPrograms=("${commonPrograms[@]}")

if (( isMacOs ))
  then allPrograms+=("${macOsPrograms[@]}")
  else allPrograms+=("${linuxPrograms[@]}")
fi

[[ ! -d ~/.config ]] && mkdir ~/.config

# Run link programs and run setup functions
for program in "${allPrograms[@]}"; do
  if [[ -d $program/home ]]; then
    print "Linking ${program}..."
    stow -d $program -t .. home
  else
    print "Program without home directory: $program"
  fi

  if [[ -n "$skipSetup" ]]; then
    continue
  fi

  local setupPath=$program/${program}.setup.zsh

  if [[ -f $setupPath ]]; then
    print "Setup ${program}..."
    source $setupPath
  fi
done
