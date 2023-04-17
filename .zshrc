# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kdehairy/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /usr/share/doc/pkgfile/command-not-found.zsh

#aliases
alias ls='ls --color=auto'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR=nvim


if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec sway
fi
