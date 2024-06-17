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
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.bck/ --work-tree=$HOME'
alias gdiff='git difftool'


export EDITOR=nvim

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

#Wayland specific
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XDG_CURRENT_DESKTOP=sway

#golang
export PATH=$PATH:$(go env GOPATH)/bin

# custome scripts
[ -d .zshrc.d ] && for f in $(find .zshrc.d -type f);do source $f;done


if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec sway
fi
