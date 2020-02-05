function git-export -d "Export all versions of file or directory"

  set -l repo=(git rev-parse --show-toplevel)
  if $status ;
    echo "Not in a git repository"
  end
end
