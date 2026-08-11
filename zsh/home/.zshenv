ulimit -n 10240

source "$HOME/.cargo/env"
export GOROOT=$HOME/go
export GOPATH=$HOME/gopath
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
declare -r commonRofiProps="-show -dmenu -no-custom -sort -sorting-method fzf"
declare -r commonChooseGuiProps="-c 3deff2 -w 40"
export PATH=~/.zsh-spell-book/src/charms:$PATH
export PATH=~/.zsh-spell-book/src/temp/charms:$PATH
export PATH=~/.zsh-spell-book/src-go/bin:$PATH
export PATH=~/.zsh-spell-book/src-rust/bin:$PATH
export PATH=~/.zsh-spell-book/src-bun/bin:$PATH
declare ZSB_GTD_FILE=~/notebook/quickNotes/gtd.md

source ~/temp/current-ticket.zsh
source ~/temp/.zshenv
