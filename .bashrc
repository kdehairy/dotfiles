#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#	ssh-agent > ~/.ssh-agent-env
#fi
#if [[ "$SSH_AGENT_PID" == "" ]]; then
#	eval "$(<~/.ssh-agent-env)"
#fi

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
