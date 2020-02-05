function git-export -d "Export all versions of file or directory"

  set -l repo (git rev-parse --show-toplevel)
  if [ $status -ne 0 ] ;
    echo "Not in a git repository"
  end

  # TODO
end
