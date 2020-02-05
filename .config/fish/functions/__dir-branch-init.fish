function __dir-branch-init
  # Reset index if stale
  if test "$dir_branch_cur" != "$PWD";
    set -g dir_branch_cur "$PWD"
    set -g dir_branch_idx 1
  end
end
