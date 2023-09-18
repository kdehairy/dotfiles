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
alias gdiff='git difftool'


export EDITOR=nvim

source ${HOME}/bin/bssh.sh
source ${HOME}/bin/bpass.sh

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

#okta
export OKTA_ORG_DOMAIN=okta.booking.com
export OKTA_OIDC_CLIENT_ID=0oa69l79n9U8sx5if417
export OKTA_AWS_ACCOUNT_FEDERATION_APP_ID=0oa1t1ub0fkS0kbyp416
export OKTA_AWSCLI_FORMAT=aws-credentials
export OKTA_AWSCLI_WRITE_AWS_CREDENTIALS=true
export OKTA_AWSCLI_OPEN_BROWSER=true

#Wayland specific
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XDG_CURRENT_DESKTOP=sway

#golang
export PATH=$PATH:$(go env GOPATH)/bin


if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec sway
fi
