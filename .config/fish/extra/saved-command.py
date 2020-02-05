#!/usr/bin/env python2.7

def usage():
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
