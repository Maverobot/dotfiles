#!/usr/bin/env bash

# Download dotfiles from github
if [ ! -d $(eval echo "~/.dotfiles") ]; then
    git clone https://github.com/Maverobot/dotfiles.git ~/.dotfiles
else
    echo "The folder ~/.dotfiles already exists."
fi

# Install i3wm dependencies
echo ""
sudo apt install i3-wm i3status i3lock xautolock suckless-tools

# #---Install i3wm config---# #
if [ ! -d $(eval echo "~/.config") ]; then
    mkdir -p ~/.config
    echo "Folder .config is created under ~/"
fi

if [ ! -d $(eval echo "~/.config/i3") ]; then
    ln -s ~/.dotfiles/.config/i3 ~/.config/
    echo -e "\nThe i3 config added!" 
else
    echo -e "\nThe i3 config already exists under ~/.config"
fi

