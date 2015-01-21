# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias ld='ll | grep ^d'
alias ..='cd ..'

alias ssh='ssh -A' # agents

# speed up grep
export GREP_OPTIONS='--color=auto --exclude=*tmp --exclude=*.pyc --exclude=#* --exclude=*~ --exclude=*.json --exclude-dir=migrations --exclude-dir=img_upload --exclude-dir=logs --exclude-dir=oldmigrations'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Quick apt-get
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias upgrade='sudo apt-get upgrade'
alias update='sudo apt-get update'

# GITRDONE
alias gs='git status'
alias gpl='git pull --rebase'
alias gps='git push'
alias gcam='git commit -am'
alias go='git checkout'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias glgb='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --branches'
alias delmerged='git checkout develop && git branch --merged | grep -v \* | grep -v master | grep -v develop | xargs git branch -d && git remote prune origin'

alias pep8='pep8  --exclude=migrations --ignore=E501 --repeat .'
alias pylint='pylint --rcfile=pylint.rc'

alias rhino='java -jar ~/rhino1_7R3/js.jar'
alias csslint='rhino ~/csslint-rhino.js'

export EDITOR=emacs

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
fi

# Keychain
#/usr/bin/keychain $HOME/.ssh/id_rsa
#source $HOME/.keychain/$HOSTNAME-sh

#---------------------
# SSH keychain
#----------------------

# keys to use
CERTFILES=" keyname keyname2 "

# find the keychain script
KEYCHAIN=
[ -x /usr/bin/keychain  ] && KEYCHAIN=/usr/bin/keychain
[ -x ~/usr/bin/keychain  ] && KEYCHAIN=~/usr/bin/keychain
[ -x ~/bin/keychain  ] && KEYCHAIN=~/bin/keychain

HOSTNAME=`hostname`
if [ -n $KEYCHAIN ] ; then
#
# If there's already a ssh-agent running, then we know we're on a desktop or laptop (i.e. a client),
# so we should run keychain so that we can set up our keys, please.
#
    if [ ! "" = "$SSH_AGENT_PID" ]; then

        echo "Keychain: SSH_AGENT_PID is set, so running keychain to load keys."
        $KEYCHAIN $CERTFILES && source ~/.keychain/$HOSTNAME-sh

# Else no ssh-agent configured
    else

#
#  Offer to run keychain only if no SSH_AUTH_SOCK is set, and# only if we aren't at the end of a ssh connection with agent# forwarding enabled (since then we won't need ssh-agent here anyway)
#
       if [ -z $SSH_AUTH_SOCK ]; then
           echo "Keychain: Found no SSH_AUTH_SOCK, so running keychain to start ssh-agent & load keys."
           $KEYCHAIN $CERTFILES && source ~/.keychain/$HOSTNAME-sh
       fi
    fi
fi
unset CERTFILES KEYCHAIN

# Colors
[ -e "$HOME/.dircolors" ] && DIR_COLORS="$HOME/.dircolors"
[ -e "$DIR_COLORS" ] || DIR_COLORS=""
[ -e "/usr/bin/dircolors" ] && eval "`dircolors -b $DIR_COLORS`"

alias emacs='emacs -nw'

[ -e "/usr/local/bin/virtualenvwrapper.sh" ] && source /usr/local/bin/virtualenvwrapper.sh

if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi

PATH=$PATH:~/bin

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
