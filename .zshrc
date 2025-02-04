get_os_name() {
    echo "$(uname -s | cut -c1-5)"
}

OS_NAME=$(get_os_name)
PROMPT_STRING="%F{2}%n@%m%f (%F{3}$OS_NAME%f) %F{4}%~%f %# "

PS1="$PROMPT_STRING"

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/emmett/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
