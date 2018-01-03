# source lwbins
for file in ~/dotfiles/lwbin/zshrc.d/*.zsh; do
	source "$file"
done

PATH=${PATH}:${HOME}/dotfiles/lwbin/bin