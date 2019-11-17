function __select
    read --local --array --null arr
    echo $arr[$argv]
end

function fish_run_any_of
    for p in $argv
        set p_name (echo $p | string split ' ' | __select 1)
        if type -q $p_name
            echo "Run '$p'"
            if eval $p
                return 0
            end
        end
    end
    echo "Failed to find any of the listed programs: $argv"
    return 1
end
