#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias s='startx'
alias x='exit'

alias ins='sudo pacman -S '
alias rem='sudo pacman -Rns'
alias pcc='sudo pacman -Scc'

alias com='sudo make clean install' 

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='\[\e[1;36m\]┌─[\u@\h]\[\e[0m\] \[\e[1;35m\]\w\[\e[0m\]\n\[\e[1;36m\]└─❯ \[\e[0m\]'
fastfetch
