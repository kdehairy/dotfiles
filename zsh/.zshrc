# Start configuration added by Zim install
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

{{#unless usingZimComp}}
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kdehairy/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
{{/unless}}

{{#if isArch}}
source /usr/share/doc/pkgfile/command-not-found.zsh
{{/if}}

#aliases
alias ls='ls --color=auto'
alias gdiff='git difftool'


export EDITOR=nvim

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

# XDG
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_CONFIG_DIRS=/etc/xdg

#Wayland specific
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export XDG_CURRENT_DESKTOP=sway

export PATH=$PATH:${HOME}/.local/bin

# custome scripts
[ -d .zshrc.d ] && for f in $(find .zshrc.d -type f);do source $f;done

#golang
export GOPATH=${XDG_DATA_HOME}/go
export GOMODCACHE=${XDG_CACHE_HOME}/go/mod
export PATH=$PATH:${GOPATH}/bin

#gpg-agent
unset SSH_AGENT_PID
SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null


{{#if dotter.packages.sway}}
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec sway
fi
{{/if}}
