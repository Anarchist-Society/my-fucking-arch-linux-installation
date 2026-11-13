#
# ~/.bashrc
#

# Si no se está ejecutando de forma interactiva, no hacer nada
[[ $- != *i* ]] && return

# Colorear salida de ls y grep
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Prompt: usuario@hostname directorio_actual $
PS1='\[\e[0;32m\][\u@\h]\[\e[0m\] \[\e[0;34m\][\W]\[\e[0m\]\[\e[1;31m\] \$\[\e[0m\] '

# Modo Vi en la terminal
set -o vi

# opencode
export PATH=/home/anarchist-penguin/.opencode/bin:$PATH

# Paquetes globales de npm
export PATH="$HOME/.npm-global/bin:$PATH"

# Personalizar prompt de sudo con colores
export SUDO_PROMPT="$(tput setab 1 setaf 7 bold)[sudo]$(tput sgr0) $(tput setaf 6)password for$(tput sgr0) $(tput setaf 5)%p$(tput sgr0): "

# kitty ssh fix
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"

# Shell wrapper Yazi
function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}
