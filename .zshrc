# ensure common tools

# ohmyzsh
if [ ! -d ~/.oh-my-zsh ]; then
    cp ~/.zshrc .zshrc.bak
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # Above command overwrites zshrc, so re-overwrite
    mv .zshrc.bak ~/.zshrc
fi
export ZSH="$HOME/.oh-my-zsh"

# pl10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# zsh theme settings
ZSH_THEME="powerlevel10k/powerlevel10k"
RPROMPT='[%D{%L:%M:%S %p}]'
TMOUT=1
TRAPALRM() {
    zle reset-prompt
}

plugins=(git)

source $ZSH/oh-my-zsh.sh

# fonts
if [ ! -d ~/.local/share/fonts/NerdFonts ]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/git/nerd-fonts
    $(cd ~/git/nerd-fonts && ./install.sh)
fi

# rust
if ! cargo_loc="$(type -p "cargo")" || [[ -z $cargo_loc ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# mdcat
if ! mdcat_loc="$(type -p "mdcat")" || [[ -z $mdcat_loc ]]; then
    cargo install mdcat
fi

# lsd
if ! lsd_loc="$(type -p "lsd")" || [[ -z $lsd_loc ]]; then
    cargo install lsd
fi
export PATH=$PATH:~/.cargo/bin

# git
if ! git_loc="$(type -p "git")" || [[ -z $git_loc ]]; then
    sudo apt install git
fi

# jj
if ! jj_loc="$(type -p "jj")" || [[ -z $jj_loc ]]; then
    sudo apt install libssl-dev openssl pkg-config build-essential
    cargo install --locked --bin jj jj-cli
fi

# nvm
if ! typeset -f nvm > /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="~/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# node
if ! npm_loc="$(type -p "npm")" || [[ -z $npm_loc ]]; then
    nvm install node
fi

# General shell shortcuts
alias pws='pwd; ls'
alias pwl='pwd; l'
alias ls='$(which lsd) --hyperlink auto --color auto'
alias l='$(which lsd) --hyperlink=auto --color auto -halF'
alias htop='sudo htop'
alias bell='echo "\a"'

# takes 0 or 1 arguments. if 0, this is equivalent to `cd ..`. if 1, will ensure the argument is a positive integer and then cd that number of levels up.
function cdu() {
    local dirstr=".."
    if [[ $# -gt 0 ]]
    then
        if ! [[ "$1" = <-> ]]
        then
        echo "Argument must be a nonnegative integer but was $1"
        return 1
        fi

        if [[ $1 = 0 ]]
        then
        echo "I mean I guess you can stay put if you want..."
        return 0
        elif [[ $1 -gt 1 ]]
        then
        for i in {2..$1}
        do
            dirstr="$dirstr/.."
        done
        fi
    fi
    cd $dirstr
}

function cws() {
    cdu $@
    pws
}

function cwl() {
    cdu $@
    pwl
}

# Git shortcuts
alias gad='git add'
alias grm='git rm'
alias gcom='git commit -m'
alias gca='git commit -am'
alias gcoma='git commit --amend'
alias grb='git rebase'
alias gir='git rebase -i'
alias grbnext='git add --all && git rebase --continue ; git status'
function gmer() {
    if [[ $# = 0 ]]
    then
        echo "Need branch name"
    else
        git merge --no-ff -m "Merge branch \"$1\" into \"$(git rev-parse --abbrev-ref HEAD)\"" $1
    fi
}
alias push='git push'
alias pushf='git push --force-with-lease'
alias pull='git pull'
alias pa='git pull --all'
alias fetch='git fetch'
alias stash='git stash'
alias spop='git stash pop'
alias gchk='git checkout'
alias gcb='git checkout -b'
alias glog='git log --pretty=oneline'
alias gst='git status'
alias gdif='git diff'
alias gsdif='git diff --shortstat'
alias gndif='git diff --name-only'
function gbdesc() {
    if [[ $# = 0 ]]
    then
        local branch=$(git rev-parse --abbrev-ref HEAD)
        echo "$(git config branch.$branch.description)"
    else
        echo "$(git config branch.$1.description)"
    fi
}
alias gbs='git bisect start'
alias good='git bisect good'
alias bad='git bisect bad'

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    source ~/dotfiles/.zshrc_wsl
fi

