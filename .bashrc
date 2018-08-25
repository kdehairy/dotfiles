#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1=$'\e[38;5;17m\u@\h [ \e[38;5;18m\W\e[38;5;17m ]\$ \n  \e[1;38;5;27m\u21b3\e[0m '


alias ls='ls --color=auto'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
