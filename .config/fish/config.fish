# Enable vi mode (compatible with emacs projectile)
fish_vi_key_bindings 2>/dev/null

# Use block in normal mode, line in insert mode, underscore in replace mode
fish_vi_cursor
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_visual block

# Workaround for fish shell in kitty. Might cause bad side effects.
set TERM xterm-256color

# Define abbreviations
abbr l 'ls'
abbr q 'exit'
abbr r 'ranger'
abbr c 'fish_run_any_of chromium-browser google-chrome'
abbr vi 'emacsclient -t'

# "A Dog" = git log --all --decorate --oneline --graph
abbr lg 'git log --all --decorate --oneline --graph'

# Select audio output
alias audio-hdmi='pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo'
alias audio-laptop='pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo'

# cmake + make
function m
    if test -f ./CMakeLists.txt
        mkdir -p build && cd build && cmake .. -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release && make
    else if test -f ./Makefile
        make
    end
end

# Corona cli
function coro
    if set -q argv
        curl -s "https://corona-stats.online/$argv[1]"
    else
        curl -s https://corona-stats.online/
    end
end

# Define customized keybindings
function fish_user_key_bindings
    bind --preset -M insert \ck up-or-search
    bind --preset -M insert \cj down-or-search
    bind --preset -M insert \ch backward-char
    bind --preset -M insert \cl forward-char
end

# Install fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

source /opt/ros/melodic/share/rosbash/rosfish
bass source /opt/ros/melodic/setup.bash
# For being compatible with anti-term in spacemacs
function fish_title
    true
end
