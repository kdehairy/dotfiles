# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch
unsetopt beep notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kdehairy/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /usr/share/doc/pkgfile/command-not-found.zsh

# Prompt
function _current_dir() {
	local _max_length="55"
	if [[ $(echo -n $PWD | wc -c) -gt ${_max_length} ]]; then
		echo "%-2~ ... %3~"
	else
		echo "%~"
	fi
}
function precmd_vcs_info() {
	vcs_info
}

precmd_functions+=( precmd_vcs_info )
autoload -Uz vcs_info
setopt PROMPT_SUBST
PROMPT=$'\n%{\e[38;5;25m%}$(_current_dir) %{\e[32m%}$vcs_info_msg_0_\n  %{\e[1;38;5;27m%}\u21b3 %#%{\e[0m%} '
zstyle ':vcs_info:git:*' formats '[ %b ]'


alias ls='ls --color=auto'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias gdiff='git difftool'
alias img='feh --auto-rotate --scale-down'

export EDITOR=nvim

# Sart ssh-agent on login
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

eval "$(starship init zsh)"

if [[ -z $DISPLAY ]] && [[ "$(tty)" == "/dev/tty1" ]]; then
  exec sway
fi
