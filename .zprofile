[[ -f ~/.zshrc ]] && . ~/.zshrc

if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec ssh-agent startx
fi

if [ -d "$HOME/opt/adb-fastboot/platform-tools" ]; then
	export PATH="$HOME/opt/adb-fastboot/platform-tools:$PATH"
fi
