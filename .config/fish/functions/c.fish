# Defined in - @ line 1
function c --description 'alias c=saved-command run'
	saved-command run $argv;
end

complete -k -f -c c -n "__fish_nth_argument 1" -a "(saved-command _complete)"
