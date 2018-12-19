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
ln -s ~/.dotfiles/.config/i3 ~/.config/i3
```

## Emacs as Daemon
To configure emacs as a daemon which runs at startup:
```
# Create soft link in ~/.config
ln -s ~/.dotfiles/.config/systemd ~/.config/systemd

# Enable the service
systemctl enable --user emacs
systemctl start --user emacs
```
