# Defined in - @ line 1
function cf --description 'alias cf=saved-command forget'
	saved-command forget $argv;
end

complete -f -c cf -n "__fish_nth_argument 1" -a "all (saved-command _complete)"
