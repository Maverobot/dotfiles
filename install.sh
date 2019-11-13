#!/usr/bin/env bash

add_ppa_safe() {
    for i in "$@"; do
        grep -h "^deb.*$i" /etc/apt/sources.list.d/* > /dev/null 2>&1
        if [ $? -ne 0 ]
        then
            echo "Adding ppa:$i"
            sudo add-apt-repository -y ppa:$i
        else
            echo "ppa:$i already exists"
        fi
    done
}

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
    cd ~/.dotfiles
    git submodule update --init --recursive
else
    echo "The folder ~/.dotfiles already exists."
    cd ~/.dotfiles
    git pull
    git submodule update --init --recursive
fi

# Install i3-gaps
add_ppa_safe kgilmer/speed-ricer
sudo apt update
sudo apt install i3-gaps

# Install i3wm dependencies
echo ""
sudo apt install i3status i3blocks i3lock compton xautolock suckless-tools arandr dunst xclip mps-youtube zathura sxiv entr feh fonts-font-awesome w3m-img python3-pip scrot byzanz udiskie fcitx-googlepinyin
echo ""
pip3 install --user ranger-fm youtube-dl

# Install kitty terminal emulator locally
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/kitty.app/bin/kitty 50
sudo update-alternatives --set x-terminal-emulator ~/.local/kitty.app/bin/kitty

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
create_soft_link "~/.dotfiles/.config/dunst" "~/.config/dunst"
create_soft_link "~/.dotfiles/.config/kitty" "~/.config/kitty"
create_soft_link "~/.dotfiles/.scripts" "~/.scripts"

systemctl enable --user emacs
systemctl start --user emacs

# Setup nmcli aliases
echo_safe "alias wifi='nmcli device wifi'" "~/.bash_aliases"
echo_safe "alias network='nmcli device'" "~/.bash_aliases"
# Setup emacsclient (terminal) with alias: vi (short for evil, vim-style)
echo_safe "alias vi='emacsclient -t'" "~/.bash_aliases"
# Setup emacsclient (gui) with alias: emacs (for emacs, gui-style)
echo_safe "alias emacs='emacsclient -nc'" "~/.bash_aliases"
# Add GOPATH to PATH
echo_safe 'export GOPATH="$HOME/go"' "~/.profile"
echo_safe 'export PATH="$PATH:$GOPATH/bin"' "~/.profile"
# Add .script to PATH
echo_safe 'export PATH="$PATH:$HOME/.scripts"' "~/.profile"
# Add ~/.local/bin to PATH
echo_safe 'export PATH="$PATH:$HOME/.local/bin"' "~/.profile"
# Add force 256 corlor
echo_safe 'export TERM=xterm-256color' "~/.bashrc"
# Add term style
echo_safe 'export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"' "~/.bashrc"
# Enable vim mode in bash and show insert/normal mode
echo_safe 'set -o vi' "~/.bashrc"
echo_safe "$(cat ~/.dotfiles/.config/.inputrc)" "~/.inputrc"
# Allow cd into directory by merely typing the name
echo_safe 'shopt -s autocd' "~/.bashrc"
# Add cd with history
echo_safe 'source ~/.dotfiles/.scripts/cd_history.sh' "~/.bashrc"
