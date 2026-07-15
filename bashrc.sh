#
# ~/.bashrc
#

# Si no se está ejecutando de forma interactiva, no hacer nada
[[ $- != *i* ]] && return

# Colorear salida de ls y grep
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Prompt: usuario@hostname directorio_actual $
PS1='[\u@\h \W]\$ '

# Modo Vi en la terminal
set -o vi

# opencode
export PATH=/home/anarchist-penguin/.opencode/bin:$PATH

# Paquetes globales de npm
export PATH="$HOME/.npm-global/bin:$PATH"

# Personalizar prompt de sudo con colores
export SUDO_PROMPT="$(tput setab 1 setaf 7 bold)[sudo]$(tput sgr0) $(tput setaf 6)password for$(tput sgr0) $(tput setaf 5)%p$(tput sgr0): "
