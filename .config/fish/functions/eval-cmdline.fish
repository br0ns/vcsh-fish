function eval-cmdline
    commandline (eval (commandline -b))
    # set -l buf (commandline -b)
    # set -l job (commandline -j)
    # set -l bc (string length (commandline -bc))
    # set -l jc (string length (commandline -jc))
    # set -l i (math $bc - $jc - 1)
    # set -l j (math $i + (string length $job) + 3)
    # set -l pre (string sub -l $i -- "$buf")
    # set -l suf (string sub -s $j -- "$buf")
    # set -l new $pre(eval $job)$suf
    # commandline -- $new
end
