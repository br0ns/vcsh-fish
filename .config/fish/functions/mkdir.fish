function mkdir --wraps mkdir
    if set -l i (contains -i -- --cd $argv)
        set -e argv[$i]
        mkcd $argv
    else
        command mkdir -pv $argv
    end
end
