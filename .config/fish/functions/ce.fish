# Defined in - @ line 1
function ce --description 'alias ce=saved-command edit'
	saved-command edit $argv;
end

complete -f -c ce -n "__fish_nth_argument 1" -a "(saved-command _complete)"
