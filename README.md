# dotfiles
This is my personal dotfiles, which contains configurations of:
* i3wm
* Emacs as daemon

# Installation
```
git clone https://github.com/Maverobot/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

# Configurations 
## i3wm
To install the i3 window manager:
```
# Install dependencies
sudo apt install i3-wm i3status i3lock xautolock suckless-tools arandr dunst

# Create soft link in ~/.config
ln -s ~/.dotfiles/.config/i3 ~/.config/
```

## Emacs as Daemon
To configure emacs as a daemon which runs at startup:
```
# Create soft link in ~/.config
ln -s ~/.dotfiles/.config/systemd ~/.config/

# Enable the service
systemctl enable --user emacs
systemctl start --user emacs

# Setup emacsclient (terminal) with alias: vi (short for evil, vim-style) 
echo "alias vi='emacsclient -t'" >> ~/.bash_aliases

# Setup emacsclient (gui) with alias: emacs (for emacs, gui-style) 
echo "alias emacs='emacsclient -nc'" >> ~/.bash_aliases
```

## Install scripts
```
# Create soft link ~/.scripts
ln -s ~/.dotfiles/.scripts ~/.scripts

# Add ~/.scripts to $PATH
echo 'PATH="$PATH:$HOME/.scripts"' >> ~/.profile
```
