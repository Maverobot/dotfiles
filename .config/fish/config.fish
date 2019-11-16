fish_vi_key_bindings 2>/dev/null

function fish_user_key_bindings
    bind --preset -M insert \ck up-or-search
    bind --preset -M insert \cj down-or-search
    bind --preset -M insert \ch backward-char
    bind --preset -M insert \cl forward-char
end

function fish_title
    true
end

