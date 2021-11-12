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
abbr we 'weather'
abbr t 'tldr'
abbr l 'ls'
abbr q 'exit'
abbr r 'ranger'
abbr c 'fish_run_any_of chromium-browser google-chrome'
abbr vi 'emacsclient -tc'
abbr vi-x 'emacsclient -n'
abbr apt-upgrade 'sudo apt update && sudo apt upgrade'

# "A Dog" = git log --all --decorate --oneline --graph
abbr lg 'git log --all --decorate --oneline --graph'

# Select audio output
alias audio-hdmi='pacmd set-card-profile 0 output:hdmi-stereo+input:analog-stereo'
alias audio-laptop='pacmd set-card-profile 0 output:analog-stereo+input:analog-stereo'

# cmake + make
function m --argument-names 'build_type'
    if type -q ninja
        set use_ninja "-GNinja"
    end

    function run_cmake_build --inherit-variable use_ninja
        cmake .. $use_ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=$build_type && cmake --build . -- -j(nproc)
        functions -e run_cmake_build
    end

    if test -z $build_type
        set build_type 'Release'
    end
    if test -f ./CMakeLists.txt
        mkdir -p build && cd build && run_cmake_build
    else if test -f ./Makefile
        if test -f ../CMakeLists.txt
            run_cmake_build
        else
            cmake --build . -- -j(nproc)
            echo "Failed to set CMAKE_BUILD_TYPE."
        end
    else if test -f ../CMakeLists.txt
        cd .. && mkdir -p build && cd build && run_cmake_build
    else
        echo "No CMakeLists.txt or Makefile found."
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

# Weather cli
function weather
    if count $argv >/dev/null
        curl wttr.in/$argv[1]
    else
        curl wttr.in/augsburg
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
    set -q XDG_CONFIG_HOME or set XDG_CONFIG_HOME ~/.config
    curl -sL https://git.io/fisher | source
end

if test -d /opt/ros/melodic
    source /opt/ros/melodic/share/rosbash/rosfish
    bass source /opt/ros/melodic/setup.bash
end

# The one and only cheatsheet
function cheat
    curl cheat.sh/$argv
end
complete -c cheat -xa '(curl -s cheat.sh/:list)'

# For being compatible with anti-term in spacemacs
function fish_title
    true
end

set fish_greeting
