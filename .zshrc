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

export EDITOR=vim
