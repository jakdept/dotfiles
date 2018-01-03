# source lwbins
for file in ~/dotfiles/lwbins/zshrc.d/*.zsh; do
	source "$file"
done

PATH=${PATH}:~/dotfiles/lwbins/bin