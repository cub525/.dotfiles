get_os_name() {
    echo "$(uname -s | cut -c1-6)"
}

OS_NAME=$(get_os_name)
PROMPT="%F{2}%n@%m%f (%F{3}$OS_NAME%f) %F{4}%~%f %# "

export KEYTIMEOUT=1

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/emmett/.zshrc'

fpath+=/.zfunc
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
# bindkey -v
# End of lines configured by zsh-newuser-install
