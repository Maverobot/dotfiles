#!/usr/bin/env bash

trap 'echo "Error happened. Exiting script."; exit' ERR

add_ppa_unique() {
	for i in "$@"; do
		if ! grep -h "^deb.*$i" /etc/apt/sources.list.d/* >/dev/null 2>&1; then
			echo "Adding ppa:$i"
			# -n for not updating
			sudo add-apt-repository -n -y "ppa:$i"
		else
			echo "ppa:$i already exists"
		fi
	done
}

# Check if content of folderes or files are the same
is_same() {
	if [ "$(diff -r "$(eval echo $1)" $(eval echo $2))" ]; then
		false
	else
		true
	fi
}

# Prevent redundantly echong to a file
try_echo() {
	if [ $# -ne 2 ]; then
		echo "Wrong input of function ${FUNCNAME[0]}"
		return
	fi
	if grep -Fxq "$1" "$(eval echo $2)" &>/dev/null; then
		return
	fi
	echo "$1" >>"$(eval echo $2)"
}

# Get user confirmation in console
confirm() {
	while true; do
		read -p "Continue (y/n)?" choice
		case "$choice" in
		y | Y)
			echo "yes"
			break
			;;
		n | N)
			echo "no"
			break
			;;
		*) ;;
		esac
	done
}

# Create a softlink to the folder under .config
create_soft_link() {
	src=$(eval echo "$1")
	dest=$(eval echo "$2")
	# Check if the src folder exists
	if [ ! -d "${src}" ]; then
		echo -e "\n ${src} does not exist."
		return
	fi
	if [ ! -d "${dest}" ]; then
		ln -sT "${src}" "${dest}"
		echo -e "Soft link of ${src} has been created at ${dest}"
	elif is_same "${src}" "${dest}"; then
		echo -e "A same ${dest} already exists. SKIP."
	else
		echo -e "\nA different ${dest} already exists. Do you want to overwrite it?"
		case "$(confirm)" in
		"yes")
			cp -rf "${dest}" /tmp
			rm -r "${dest}"
			ln -sT "${src}" "${dest}"
			echo "${dest} has been moved to /tmp"
			echo "Soft link of ${src} has been created at ${dest}"
			;;
		"no") echo "${dest} is left untouched" ;;
		esac
	fi
}

install_soft_link() {
	name=$1
	src="${HOME}/.dotfiles/${name}"
	dest="${HOME}/${name}"
	create_soft_link "${src}" "${dest}"
}

# Download dotfiles from github
if [ ! -d "$(eval echo "${HOME}/.dotfiles")" ]; then
	git clone https://github.com/Maverobot/dotfiles.git ~/.dotfiles
	cd ~/.dotfiles || exit
	git submodule update --init --recursive
else
	echo "The folder ~/.dotfiles already exists."
	cd ~/.dotfiles || exit
	git pull
	git submodule update --init --recursive
fi

# Add PPAs
add_ppa_unique kgilmer/speed-ricer
add_ppa_unique fish-shell/release-3
sudo apt -qq update

# Install i3wm dependencies
echo ""
sudo apt -qq install fish i3-gaps i3status i3blocks i3lock xautolock suckless-tools arandr dunst xclip mps-youtube zathura sxiv entr feh fonts-font-awesome w3m-img python3-pip scrot byzanz udiskie fcitx-googlepinyin yad xdotool neofetch
echo ""
pip3 install --user ranger-fm youtube-dl pygments gdbgui
echo ""
sudo snap install peco
echo ""

# Install kitty terminal emulator locally
if [ ! "$(command -v kitty)" ]; then
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator ~/.local/kitty.app/bin/kitty 50
	sudo update-alternatives --set x-terminal-emulator ~/.local/kitty.app/bin/kitty
fi

# Install gdb-dashboard
wget -P ~ https://git.io/.gdbinit

# #---Install i3wm config---# #
if [ ! -d "$(eval echo "${HOME}/.config")" ]; then
	mkdir -p ~/.config
	echo "Folder .config is created under ~/"
fi

install_soft_link ".config/i3"
install_soft_link ".config/systemd"
install_soft_link ".config/ranger"
install_soft_link ".config/dunst"
install_soft_link ".config/kitty"
install_soft_link ".config/fish"
install_soft_link ".config/rofi"
install_soft_link ".scripts"

systemctl enable --user emacs
systemctl start --user emacs

# Setup nmcli aliases
try_echo "alias wifi='nmcli device wifi'" "${HOME}/.bash_aliases"
try_echo "alias network='nmcli device'" "${HOME}/.bash_aliases"
# Setup emacsclient (terminal) with alias: vi (short for evil, vim-style)
try_echo "alias vi='emacsclient -t'" "${HOME}/.bash_aliases"
# Setup emacsclient (gui) with alias: emacs (for emacs, gui-style)
try_echo "alias emacs='emacsclient -nc'" "${HOME}/.bash_aliases"
# Add GOPATH to PATH
try_echo 'export GOPATH="${HOME}/go"' "${HOME}/.profile"
try_echo 'export PATH="$PATH:$GOPATH/bin"' "${HOME}/.profile"
# Add .script to PATH
try_echo 'export PATH="$PATH:$HOME/.scripts"' "${HOME}/.profile"
# Add ~/.local/bin to PATH
try_echo 'export PATH="$PATH:$HOME/.local/bin"' "${HOME}/.profile"
# Add force 256 corlor
try_echo 'export TERM=xterm-256color' "${HOME}/.bashrc"
# Enable vim mode in bash and show insert/normal mode
try_echo 'set -o vi' "${HOME}/.bashrc"
try_echo "$(cat ~/.dotfiles/.config/.inputrc)" "${HOME}/.inputrc"
# Allow cd into directory by merely typing the name
try_echo 'shopt -s autocd' "${HOME}/.bashrc"
