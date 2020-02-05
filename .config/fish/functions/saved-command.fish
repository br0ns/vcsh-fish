# TODO: move everything to python and make this a thin wrapper

# TODO: named commands
# TODO: keep index?
# TODO: sessions
# TODO: just forget about idxs altogether?
# TODO: escape keys/commands
# TODO: parameterized commands
# TODO: validate keys ([a-zA-Z_][a-zA-Z0-9_-]*)
# TODO: key clash
# TODO: named parameters and default values:
#       $ save -k hi echo hello, %{n/name=world}
#       $ run hi -n World
#       $ save -k hi echo hello, %{1=world}
#       $ run hi

# TODO: rename export to dump, and have export define the command as a shell
#       function

# If running a single parameter command insert on command line and place cursor
# at parm

# global vars
#   _sc_cmds: saved commands
# TODO:
#   _sc_idxs: index keys
#   _sc_keys: named keys

# global: $_sc_session
# universal: $_sc_${_sc_session}_cmds
# universal: $_sc_${_sc_session}_keys

# Default to global session
set -g _sc_session global

function saved-command
    if test -z "$argv" -o "$argv" = "help"
        set -l R (set_color normal)
        set -l B "$R"(set_color --bold)
        set -l U "$R"(set_color --bold cyan)
        begin
            echo "usage: "(status function)" ACTION [...]"

            # help
            echo -n "  "$U"h"$B"elp"$R
            echo ""
            echo "    This."

            # save
            echo -n "  "$U"s"$B"ave"$R
            echo " [-k|--key KEY] [COMMAND]"
            echo "    Save COMMAND or last executed command (as KEY)."

            # forget
            echo -n "  "$U"f"$B"orget"$R
            echo " [all|CMD]"
            echo "    Delete a saved command."

            # list
            echo -n "  "$U"l"$B"ist"$R
            echo " [REGEX]"
            echo "    List saved commands.  Filter by REGEX if given."

            # run
            echo -n "  "$U"r"$B"un"$R
            echo " CMD [ARGS ...]"
            echo "    Run a saved command."

            # insert
            echo -n "  "$U"i"$B"nsert"$R
            echo " CMD [ARGS ...]"
            echo "    Insert a saved command on the command line."

            # edit
            echo -n "  "$U"e"$B"dit"$R
            echo " CMD [COMMAND]"
            echo "    Replace CMD by COMMAND or last executed command."

            # rekey
            echo -n "  "$B"re"$U"k"$B"ey"$R
            echo " CMD KEY"
            echo "    (Re)name CMD to KEY."

            # export
            echo -n "  "$B"e"$U"x"$B"port"$R
            echo " CMD [NAME]"
            echo "    Define a shell function for CMD named NAME or KEY."

            # dump
            echo -n "  "$U"d"$B"ump"$R
            echo " [--all]"
            echo "    Dump commands in current or all session(s)."

            # session
            echo -n "  "$B"session"$R
            echo " ACTION [...]"

            # list
            echo -n "    "$U"l"$B"ist"$R
            echo ""
            echo "      List all active sessions."

            # merge
            echo -n "    "$U"m"$B"erge"$R
            echo " [NAME]"
            echo "      Add all commands in this session to NAME or global."

            # switch
            echo -n "    "$U"s"$B"witch"$R
            echo " NAME"
            echo "      Change the current session."

            # rename
            echo -n "    "$U"r"$B"ename"$R
            echo " NAME"
            echo "      Rename the current session."

            # global
            echo -n "    "$U"g"$B"lobal"$R
            echo ""
            echo "      Alias for 'switch global'."

            # new
            echo -n "    "$U"n"$B"ew"$R
            echo " NAME"
            echo "      Start a new session."

            # forget
            echo -n "    "$U"f"$B"orget"$R
            echo " [NAME]"
            echo "      Delete a current session or NAME."

            echo

            ## "Types"

            # CMD
            echo -n "  "$B"CMD"$R
            echo " can be"
            echo "    - An index between 1 and the number of saved command."
            echo "    - A REGEX which uniquely identifies a saved command."
            echo "    - A unique substring of a command key."

            # COMMAND
            echo -n "  "$B"COMMAND"$R
            echo ""
            echo "    Commands can be parameterized.  Parameters take the form"\
            "%1, %2, etc.  A"
            echo "    literal % must be escaped as %%."
        end >&2
        return
    end

    set -l cmd $argv[1]
    set -e argv[1]
    switch $cmd
        case s save
            _sc_save $argv

        case f forget
            _sc_forget $argv

        case l list
            _sc_list $argv

        case r run
            _sc_run $argv

        case i insert
            _sc_insert $argv

        case e edit
            _sc_edit $argv

        case k key
            _sc_edit $argv

        case x export
            _sc_export $argv

            # For debugging
        case find
            _sc_find $argv

            # Auto completion completion
        case _complete
            _sc_complete

        case session
            set -l cmd $argv[1]
            set -e argv[1]
            switch cmd
                case ''
                    echo Missing ACTION
                    return 1

                case '*'
                    echo Unknown ACTION: "$cmd"
                    return 1
            end

        case '*'
            echo Unknown ACTION: "$cmd"
            return 1
    end
end

# Helpers
function _sc_len
    set -l var _sc_{$_sc_session}_cmds
    count $$var
end

function _sc_idxs
    seq 1 (_sc_len)
end

function _sc_cmd
    set -l var _sc_{$_sc_session}_cmds"["$argv[1]"]"
    echo $$var
end

function _sc_key
    set -l var _sc_{$_sc_session}_keys"["$argv[1]"]"
    set -l key $$var
    test -n "$key"
    echo $key
end

function _sc_show
    set -l idx $argv[1]
    set -l cmd (_sc_cmd $idx)
    set -l key (_sc_key $idx)
    and set key " "(set_color yellow)$key(set_color normal)
    echo (set_color --bold blue)$idx(set_color normal)$key")" $cmd
end

function _sc_append
    set -l key $argv[1]
    set -l cmd $argv[2]
    set -Ua _sc_{$_sc_session}_keys $key
    set -Ua _sc_{$_sc_session}_cmds $cmd
end

function _sc_delete
    set -l idx $argv[1]
    set -e _sc_{$_sc_session}_keys[$idx]
    set -e _sc_{$_sc_session}_cmds[$idx]
end

function _sc_key_match -a idx pat
    set -l key (_sc_key $idx)
    and string match --quiet "*""$pat""*" "$key"
end

function _sc_cmd_match -a idx pat
    set -l cmd (_sc_cmd $idx)
    string match --quiet --regex -- "$pat" "$cmd"
end

function _sc_idx_ok -a idx
    string match --quiet --regex '^\d+$' $idx
    and test $idx -ge 1 -a $idx -le (_sc_len)
end

function _sc_key_ok -a key
    test -n "$key"
    and string match --quiet --regex '^[a-zA-Z_][a-zA-Z0-9_-]*$' $key
end

function _sc_has_key -a key
    set -l var _sc_{$_sc_session}_keys"["$argv[1]"]"
    contains -- $key $$var
end

function _sc_num_args -a cmd

end

function _sc_find
    set -l pat "$argv"
    set -l hit false

    # By index
    if _sc_idx_ok $pat
        echo $pat
        return
    end

    # By key
    for idx in (_sc_idxs)
        if _sc_key_match $idx "$pat"
            echo $idx
            set hit true
        end
    end

    $hit ;and return

    # By cmd
    for idx in (_sc_idxs)
        if _sc_cmd_match $idx "$pat"
            echo $idx
            set hit true
        end
    end

    $hit ;and return

    return 1
end

function _sc_uniq
    set -l idxs (_sc_find $argv)
    set -l n (count $idxs)
    if test $n -eq 1
        echo $idxs[1]
        return 0
    else if test $n -eq 0
        echo No such command >&2
    else
        echo Ambiguous command >&2
        for idx in $idxs
            _sc_show $idx >&2
        end
    end
    return 1
end

function _sc_complete
    set -l pat (commandline -ct)
    set -l seen

    # By key
    for idx in (_sc_idxs)
        if _sc_key_match $idx "$pat"
            if not contains $idx $seen
                set -a seen $idx
                set -l cmd (_sc_cmd $idx)
                set -l key (_sc_key $idx)
                echo "$key"\t"$cmd"
            end
        end
    end

    # By cmd
    for idx in (_sc_idxs)
        if _sc_cmd_match $idx "$pat"
            if not contains $idx $seen
                set -a seen $idx
                set -l cmd (_sc_cmd $idx)
                if set -l key (_sc_key $idx)
                    echo "$key"\t"$cmd"
                else
                    echo "$idx"\t"$cmd"
                end
            end

        end
    end

    # By index
    if _sc_idx_ok "$pat"
        if not contains $idx $seen
            set -a seen $idx
            set -l cmd (_sc_cmd $idx)
            if set -l key (_sc_key $idx)
                echo "$key"\t"$cmd"
            else
                echo "$idx"\t"$cmd"
            end
        end
    end
end

# Sub-commands

function _sc_save
    set -l key
    set -l cmd

    # Parse -k/--key
    if contains -- "$argv[1]" -k --key ;
        if test -z "$argv[2]"
            echo Missing KEY >&2
            return 1
        else
            set key $argv[2]
        end
        set cmd "$argv[3..-1]"
    else
        set cmd "$argv"
    end

    # No command? use last
    if test -z "$cmd"
        set cmd (string join " ; " (history -1))
    end

    # Still no command?
    if test -z "$cmd"
        echo Missing COMMAND >&2
        return 1
    end

    # Already exists?
    for idx in (_sc_idxs)
        set -l k (_sc_key $idx)
        set -l c (_sc_cmd $idx)
        if test -n "$key" -a \
            "$key" = "$k" -a \
            "$cmd" = "$c"
            _sc_show $idx
            return
        end
    end

    _sc_append "$key" "$cmd"
    _sc_show (_sc_len)
end

function _sc_forget
    if test -z "$argv"
        echo Missing CMD
        return 1
    else if test "$argv" = "all"
        while test (_sc_len) -gt 0
            _sc_delete 1
        end
    else
        set -l idx (_sc_uniq $argv)
        or return
        _sc_delete $idx
    end
end

function _sc_list
    echo "["$_sc_session"]" >&2
    set -l pat "$argv"
    if test (_sc_len) -eq 0
        echo No saved commands >&2
        return 0
    end
    set -l ret 1
    for idx in (_sc_idxs)
        set -l key (_sc_cmd $idx)
        set -l cmd (_sc_cmd $idx)
        if test -z "$pat"
            or string match --quiet -- "$pat" "$key"
            or string match --quiet --regex -- "$pat" "$cmd"
            set ret 0
            _sc_show $idx
        end
    end
    if test $ret -ne 0
        echo No matching commands >&2
    end
    return $ret
end

function _sc_run
    set -l idx (_sc_uniq $argv)
    or return
    _sc_show $idx
    eval (_sc_cmd $idx)
end

function _sc_insert
    set -l idx (_sc_uniq $argv)
    or return
    commandline (_sc_cmd $idx)
end

function _sc_edit
    if test -z "$argv"
        echo Missing argument
        return 1
    end

    set -l idx (_sc_uniq $argv[1])
    or return
    set -e argv[1]

    if test -z "$argv"
        set -l cmd (_sc_cmd $idx)
        commandline "saved-command edit $idx $cmd"
        return
    else
        set cmd "$argv"
    end

    # set -l var _sc_{$_sc_session}_cmds"["$idx"]"
    set -g _sc_{$_sc_session}_cmds"["$idx"]" $cmd
    return 0
end

# TODO: all sessions
function _sc_export
    for idx in (_sc_idxs)
        echo -n "saved-command save "
        set -l key (_sc_key $idx)
        and echo -n -- --key (string escape $key)" "
        echo (string escape (_sc_cmd $idx))
    end
end
