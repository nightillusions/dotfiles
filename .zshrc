############# zplug config #############
# run
# curl -sL zplug.sh/installer | zsh
# to install zplug itself

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "plugins/pass/", from:oh-my-zsh
zplug "plugins/docker",   from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh

#fzf - load correct history file -> load fzf bin -> load fzf keybindings
zplug "sorin-ionescu/prezto", use:modules/history/init.zsh
zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"*linux*amd64*"
zplug "junegunn/fzf", use:"shell/*.zsh"

zplug "sorin-ionescu/prezto", use:modules/history/init.zsh
zplug "sorin-ionescu/prezto", use:modules/completion/init.zsh

zplug "plugins/kubectl", from:oh-my-zsh

zplug "plugins/yarn/yarn.plugin.zsh", from:oh-my-zsh

zplug "~/.zsh", from:local, use:"theme.zsh-theme", as:theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

############# exports #############
export JAVA_HOME='/usr/lib/jvm/default-java'
export IDEA_JDK='/usr/lib/jvm/default-java'

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/code/go
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOPATH/bin

SCALA_HOME=$HOME/scala
export PATH=$PATH:$SCALA_HOME/bin

export PATH=$PATH:$HOME/.config/yarn/global/node_modules/.bin
export PATH=$PATH:$HOME/scripts/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/opt/node/bin
export PATH=$PATH:/usr/lib/node_modules
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.config/composer/vendor/bin
export EDITOR='vim'

export HISTCONTROL=erasedups:ignorespace

#use exact match for fzf
export FZF_DEFAULT_OPTS="-e"

############# aliases #############
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'

BLUE='\033[0;34m'
NC='\033[0m' # No Color

alias gac='git add -A && git commit -v'
alias gd='echo "\n${BLUE}########## Cached ##########${NC}" && git --no-pager diff --cached && echo "\n${BLUE}########## Unstaged ##########${NC}" && git --no-pager diff'
alias gp='git pull & git push'
alias gs='git status'
alias gco='git checkout'
alias gl='git pull --rebase'
alias gsl='git stash && git pull --rebase'
alias gcm='git commit -m'
alias glo='git log --stat --graph --oneline | head -n 20'
alias gc='git clone'

alias ..='cd ..'
alias ....='cd ../..'
alias ......='cd ../../..'

alias aptupdate='sudo apt update'
alias aptinstall='sudo apt install'
alias aptdistupgrade='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'

alias ports='sudo netstat -tulpn'

alias mongo='sudo service mongod start'
alias mongost='sudo service mongod stop'
alias mongore='sudo service mongod restart'

alias opin='eval $(op signin my)'

alias cht='hlp'
alias hlp='cht.sh'
alias pls='php please'
alias arti='php artisan'
alias hst='sudo nano /etc/hosts'

alias grep='grep  --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias -g G='| grep -i'
alias d='dirs -v | head -10'
alias fll='ls -lah | fzf'
alias fnano='nano (fll)'
alias files='rg --files | fzf'

alias fixmouse='sudo modprobe -r psmouse && sudo modprobe psmouse'

#purge all docker images and containers
alias dockercleanall='docker rm $(docker ps -a -q) && docker rmi $(docker images -q)'
alias laradock='cd ~/code/laradock/ && docker-compose up -d nginx mysql phpmyadmin redis workspace'

take () {
	mkdir -p $1
	cd $1
}

llg () {
	ll | grep -i $1
}

cdl () {
    cd $1 && ls
}

findin () {
    cd $1 && selected_find=$(fzf)
    echo $selected_find | xclip -sel clip
}

api_token () {
    API_TOKEN=$(curl -s --request POST \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Accept: application/json' \
--data-urlencode "username=$1" \
--data-urlencode "password=$2" \
--data-urlencode "client_id=sipgate-app-web" \
--data-urlencode "grant_type=password" \
https://api.sipgate.com/login/sipgate-apps/protocol/openid-connect/token | jq -r '.access_token')
    echo 'Stored token in $API_TOKEN'
}

api_token_dev () {
    API_TOKEN_DEV=$(curl -s --request POST \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Accept: application/json' \
--data-urlencode "username=$1" \
--data-urlencode "password=$2" \
--data-urlencode "client_id=sipgate-app-web" \
--data-urlencode "grant_type=password" \
https://api.dev.sipgate.com/login/sipgate-apps/protocol/openid-connect/token | jq -r '.access_token')
    echo 'Stored token in $API_TOKEN_DEV'
}

homestead() {
    ( cd ~/Homestead && vagrant $* )
}

### PROCESS
# mnemonic: [K]ill [P]rocess
# show output of "ps -ef", use [tab] to select one or multiple entries
# press [enter] to kill selected processes and go back to the process list.
# or press [escape] to go back to the process list. Press [escape] twice to exit completely.

kp () {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
    kp
  fi
}

if [ -f "$HOME/.zsh_local" ]; then source "$HOME/.zsh_local"; fi

# use alt(arrow) to move through words
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word



export NVM_DIR="/home/pascal/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
fpath=(~/.zsh/ $fpath)
