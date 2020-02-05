set -l _sc_actions save forget list run insert edit

complete -f -c saved-command
complete -f -c saved-command -n "__fish_nth_argument 1" -a "$_sc_actions"

# Sub-commands
function _sc_complete
  set -l long $argv[1]
  set -l short (string sub -l 1 $long)
  set -e argv[1]
  complete -f -c saved-command \
           -n "__fish_seen_subcommand_from $short $long ;and \
               __fish_nth_argument 2" \
           $argv
end

function _sc_complete_command
  set -l comp (commandline -ct)
  set -l idxs (_sc_match $comp 2>/dev/null)
  for idx in $idxs
    echo $idx\t$_sc_cmds[$idx]
  end
end
_sc_complete forget -a "all (_sc_complete_command)"
_sc_complete run -a "(_sc_complete_command)"
_sc_complete insert -a "(_sc_complete_command)"
_sc_complete edit -a "(_sc_complete_command)"
