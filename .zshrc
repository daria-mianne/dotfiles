# ensure ohmyzsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # Above command overwrites zshrc, so re-overwrite
    cp ~/dotfiles/.copy_to_home_zshrc ~/.zshrc
fi

# ensure lsd
if ! lsd_loc="$(type -p "lsd")" || [[ -z $lsd_loc ]]; then
    if ! cargo_loc="$(type -p "cargo")" || [[ -z $cargo_loc ]]; then
        apt install cargo
    fi
    cargo install lsd
fi
export PATH=$PATH:~/.cargo/bin

# ensure fonts
if [ ! -d ~/.local/share/fonts/NerdFonts ]; then
    git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git ~/git/nerd-fonts
    $(cd ~/git/nerd-fonts && ./install.sh)
fi

# ensure pl10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# To import this file in your actual .zshrc file, copy and uncomment the below, fixing the path referenced:
# if [ -f /path/to/dotfiles/.zshrc ]; then
#     source /path/to/dotfiles/.zshrc
# else
#     print "404: /path/to/dotfiles/.zshrc not found."
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
RPROMPT='[%D{%L:%M:%S %p}]'
TMOUT=1
TRAPALRM() {
    zle reset-prompt
}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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
alias gca='git add . && git commit -m'
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

