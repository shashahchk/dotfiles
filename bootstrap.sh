mkdir -p $HOME/.config

# point to the correct .zshrc
cat > "$HOME/.zshenv" << 'EOF'
export ZDOTDIR="$HOME/.config/zsh"
EOF

ln -sfn $HOME/dotfiles/config/ghostty              $HOME/.config/ghostty
ln -sfn $HOME/dotfiles/config/aerospace $HOME/.config/aerospace
ln -sfn $HOME/dotfiles/config/sketchybar $HOME/.config/sketchybar
ln -sfn $HOME/dotfiles/config/fish $HOME/.config/fish
ln -sfn $HOME/dotfiles/config/nvim $HOME/.config/nvim
ln -sfn $HOME/dotfiles/config/vscode $HOME/Library/Application\ Support/Code/User
ln -sfn $HOME/dotfiles/config/zsh $HOME/.config/zsh


