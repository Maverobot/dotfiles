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
create_link_for_folder() {
    folder_name=$1
    src=$(eval echo "~/.dotfiles/.config/${folder_name}")
    dest=$(eval echo "~/.config/${folder_name}")
    echo "${dest}"
    # Check if the src folder exists
    if [ ! -d ${src} ]; then
        echo -e "\n The folder ${src} does not exist."
        return
    fi
    if [ ! -d ${dest} ]; then
        ln -s ~/.dotfiles/.config/${folder_name} ~/.config/
        echo -e "\nThe ${folder_name} config has been added!"
    else
        echo -e "\nThe ${folder_name} config already exists under ~/.config. Do you want to overwrite it?"
        case "$(confirm)" in
            "yes" ) mv ${dest} /tmp;
                    ln -s ${src} ~/.config/;
                    echo "The existing ${folder_name} config is overwritten.";;
            "no" ) echo "The existing ${folder_name} config is left untouched";;
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
sudo apt install i3-wm i3status i3lock xautolock suckless-tools arandr dunst terminator xclip mps-youtube zathura* sxiv entr compton feh
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

create_link_for_folder "i3"
create_link_for_folder "systemd"
create_link_for_folder "ranger"

systemctl enable --user emacs
systemctl start --user emacs

# Setup emacsclient (terminal) with alias: vi (short for evil, vim-style)
echo_safe "alias vi='emacsclient -t'" "~/.bash_aliases"
# Setup emacsclient (gui) with alias: emacs (for emacs, gui-style)
echo_safe "alias emacs='emacsclient -nc'" "~/.bash_aliases"

# #---Install scripts---# #
if [ ! -d $(eval echo "~/.scripts") ]; then
    ln -s ~/.dotfiles/.scripts ~/.scripts
    echo_safe 'PATH="$PATH:$HOME/.scripts"' "~/.profile"
    echo -e "\nThe .scripts folder has been added!"
else
    echo -e "\nThe .scripts folder already exists under ~/. Do you want to overwrite it?"
    case "$(confirm)" in
        "yes" ) mv ~/.scripts /tmp;
                ln -s ~/.dotfiles/.scripts ~/.scripts;
                echo_safe 'PATH="$PATH:$HOME/.scripts"' "~/.profile"
                echo "The existing .scripts folder is overwritten.";;
        "no" ) echo "The existing .scripts folder is left untouched";;
    esac
fi
