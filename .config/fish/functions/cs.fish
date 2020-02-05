# Defined in - @ line 1
function cs --description 'alias cs=saved-command save'
	saved-command save $argv;
end

# Disable path completion
complete -f -c cs
