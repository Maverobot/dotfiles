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
sudo apt install i3-wm i3status i3lock xautolock suckless-tools arandr dunst terminator xclip mps-youtube zathura* sxiv entr
echo ""
pip3 install --user youtube-dl

# #---Install i3wm config---# #
if [ ! -d $(eval echo "~/.config") ]; then
    mkdir -p ~/.config
    echo "Folder .config is created under ~/"
else
    echo "Folder .config already exits under ~/"
fi

if [ ! -d $(eval echo "~/.config/i3") ]; then
    ln -s ~/.dotfiles/.config/i3 ~/.config/
    echo -e "\nThe i3 config has been added!"
else
    echo -e "\nThe i3 config already exists under ~/.config. Do you want to overwrite it?"
    case "$(confirm)" in
        "yes" ) rm ~/.config/i3;
                ln -s ~/.dotfiles/.config/i3 ~/.config/;
                echo "The existing i3 config is overwritten.";;
        "no" ) echo "The existing i3 config is left untouched";;
    esac
fi

# #---Install systemd config---# #
if [ ! -d $(eval echo "~/.config/systemd") ]; then
    ln -s ~/.dotfiles/.config/systemd ~/.config/
    # Enable the service
    systemctl enable --user emacs
    systemctl start --user emacs
    echo -e "\nThe systemd config has been added!"
else
    echo -e "\nThe systemd config already exists under ~/.config. Do you want to overwrite it?"
    case "$(confirm)" in
        "yes" ) rm ~/.config/systemd;
                ln -s ~/.dotfiles/.config/systemd ~/.config/;
                # Enable the service
                systemctl enable --user emacs
                systemctl start --user emacs
                echo "The existing systemd config is overwritten.";;
        "no" ) echo "The existing systemd config is left untouched";;
    esac
fi
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
        "yes" ) rm ~/.scripts;
                ln -s ~/.dotfiles/.scripts ~/.scripts;
                echo_safe 'PATH="$PATH:$HOME/.scripts"' "~/.profile"
                echo "The existing .scripts folder is overwritten.";;
        "no" ) echo "The existing .scripts folder is left untouched";;
    esac
fi
