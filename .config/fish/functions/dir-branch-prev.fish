function dir-branch-prev --description "Switch to next directory branch"
  __dir-branch-init
  set dir_branch_idx (math $dir_branch_idx - 1)
  commandline -f repaint
end
