source "$HOME/.cargo/env"
export GOROOT=$HOME/go
export GOPATH=$HOME/gopath
export PATH=$PATH:$GOROOT/bin
declare -r commonRofiProps="-show -dmenu -no-custom -sort -sorting-method fzf"
declare -r commonChooseGuiProps="-c 3deff2 -w 40"
export PATH=~/.zsh-spell-book/src/charms:$PATH
export PATH=~/.zsh-spell-book/go-work/bin:$PATH
export PATH=~/pdoro/bin:$PATH
export PATH=~/wcase/bin:$PATH
declare ZSB_GTD_FILE=~/notebook/quickNotes/gtd.md

source ~/temp/.zshenv
