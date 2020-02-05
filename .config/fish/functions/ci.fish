# Defined in - @ line 1
function ci --description 'alias ci=saved-command insert'
	saved-command insert $argv;
end

complete -f -c ci -n "__fish_nth_argument 1" -a "(saved-command _complete)"
