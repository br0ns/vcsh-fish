function dir-descend --description "Go to most recently visited child directory"
  __dir-branch-init

  set -l bs (dir-branches)
  set -l len (count $bs)

  if test $len -gt 0;
    if test $dir_branch_idx -gt $len;
      set dir_branch_idx 1
    end
    cd $bs[$dir_branch_idx]

    status is-interactive
    and commandline -f repaint
  end
end
