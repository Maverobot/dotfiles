#!/usr/bin/env bash

# Prevent redundantly echong to a file
echo_safe() {
    if [ $# -ne 2 ]; then
        echo "Wrong input of function ${FUNCNAME[0]}"
        return
    fi
    if grep -Fxq "$1" "$(eval echo $2)"&>/dev/null; then
        return
    fi
    echo "$1" >> "$(eval echo $2)"
}

# Get user confirmation in console
confirm() {
    while [ 1 ]; do
        read -p "Continue (y/n)?" choice
        case "$choice" in
            y|Y ) echo "yes"; break;;
            n|N ) echo "no"; break;;
            * ) ;;
        esac
    done
}

# Create a softlink to the folder under .config
create_soft_link() {
    src=$(eval echo "$1")
    dest=$(eval echo "$2")
    # Check if the src folder exists
    if [ ! -d ${src} ]; then
        echo -e "\n ${src} does not exist."
        return
    fi
    if [ ! -d ${dest} ]; then
        ln -sT ${src} ${dest}
        echo -e "\nSoft link of ${src} has been created at ${dest}"
    else
        echo -e "\n${dest} already exists. Do you want to overwrite it?"
        case "$(confirm)" in
            "yes" ) cp -r ${dest} /tmp;
                    rm -r ${dest}
                    ln -sT ${src} ${dest}
                    echo "${dest} has been moved to /tmp"
                    echo "Soft link of ${src} has been created at ${dest}";;
            "no" ) echo "${dest} is left untouched";;
        esac
    fi
}


# Download dotfiles from github
if [ ! -d $(eval echo "~/.dotfiles") ]; then
    git clone https://github.com/Maverobot/dotfiles.git ~/.dotfiles
else
    echo "The folder ~/.dotfiles already exists."
    cd ~/.dotfiles
    git pull
fi

# Install i3wm dependencies
echo ""
sudo apt install i3-wm i3status i3blocks i3lock xautolock suckless-tools arandr dunst terminator xclip mps-youtube zathura* sxiv entr compton feh fonts-font-awesome w3m-image
# For some reason, compton has to be installed so that terminator can have transparency effect.
echo ""
pip3 install --user ranger-fm youtube-dl

# #---Install i3wm config---# #
if [ ! -d $(eval echo "~/.config") ]; then
    mkdir -p ~/.config
    echo "Folder .config is created under ~/"
else
    echo "Folder .config already exits under ~/"
fi

create_soft_link "~/.dotfiles/.config/i3" "~/.config/i3"
create_soft_link "~/.dotfiles/.config/systemd" "~/.config/systemd"
create_soft_link "~/.dotfiles/.config/ranger" "~/.config/ranger"
create_soft_link "~/.dotfiles/.scripts" "~/.scripts"

systemctl enable --user emacs
systemctl start --user emacs

# Setup emacsclient (terminal) with alias: vi (short for evil, vim-style)
echo_safe "alias vi='emacsclient -t'" "~/.bash_aliases"
# Setup emacsclient (gui) with alias: emacs (for emacs, gui-style)
echo_safe "alias emacs='emacsclient -nc'" "~/.bash_aliases"
# Add .script to PATH
echo_safe 'PATH="$PATH:$HOME/.scripts"' "~/.profile"
# Add force 256 corlor
echo_safe 'export TERM=xterm-256color' "~/.bashrc"
# Enable vim mode in bash
set -o vi
# Allow cd into directory by merely typing the name
shopt -s autocd
