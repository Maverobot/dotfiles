# Enable vi mode (compatible with emacs projectile)
fish_vi_key_bindings 2>/dev/null

# Use block in normal mode, line in insert mode, underscore in replace mode
fish_vi_cursor
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_visual block

# Define abbreviations
abbr l 'ls'

# Define customized keybindings
function fish_user_key_bindings
    bind --preset -M insert \ck up-or-search
    bind --preset -M insert \cj down-or-search
    bind --preset -M insert \ch backward-char
    bind --preset -M insert \cl forward-char
end


# For being compatible with anti-term in spacemacs
function fish_title
    true
end
