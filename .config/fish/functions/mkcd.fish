function mkcd --description 'Create directory, and go to it' --wraps mkdir
    command mkdir -pv $argv;
    if test $status = 0
    switch $argv[(count $argv)]
        case '-*'

        case '*'
            cd $argv[(count $argv)]
            return
        end
    end
end
