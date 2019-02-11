
function fish_import_bash_aliases \
    --description 'import bash aliases to .fish function files.'
    for a in (cat ~/.bash_aliases  | grep "^alias")
        set aname (echo $a | sed 's/alias \(.*\)=\(\'\|\"\).*/\1/')
        set command (echo $a | sed 's/alias \(.*\)=\(\'\|\"\)\(.*\)\2/\3/')
        if test -f ~/.config/fish/functions/$aname.fish
            echo "Overwriting alias $aname as $command"
        else
            echo "Creating alias $aname as $command"
        end
        alias $aname $command
        funcsave $aname
    end
end
