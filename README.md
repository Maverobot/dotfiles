# dotfiles
This is my personal dotfiles, which contains configurations of:
* i3wm
* Emacs as daemon

# Installation
```
git clone https://github.com/Maverobot/dotfiles.git ~/.dotfiles
```

# Configurations 
## i3wm
To install the i3 window manager:
```
# Install dependencies
sudo apt install i3-wm i3status i3lock xautolock suckless-tools

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

# Setup emacsclient (terminal) with alias: ev (short for evil, vim-style) 
echo "alias ev='emacsclient -t'" >> ~/.bash_aliases

# Setup emacsclient (gui) with alias: em (short for emacs, gui-style) 
echo "alias em='emacsclient -nc'" >> ~/.bash_aliases
```
