alias tldr="tldr -o linux"
alias ls="ls --color=auto"
alias julia="julia --project=@."

if test -f ~/anaconda3/etc/profile.d/conda.sh
then
	source ~/anaconda3/etc/profile.d/conda.sh
	conda activate base
fi

export EDITOR=nvim

alias dotfile='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'

# eval "$(oh-my-posh init bash --config ~/.poshthemes/powerline-git.omp.json)"
