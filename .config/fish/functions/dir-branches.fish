function dir-branches --description "Returns branches from directory"
  # Take path as argument or use current directory
  set -l dir
  if set -q argv[1]
    set dir (realpath "$argv[1]")
  else
    set dir "$PWD"
  end

  # Remove trailing slashes, i.e. in "/"
  set dir (string trim --right --chars "/" "$dir")

  # Collect branches, most recently visited first
  set -l branches

  set -l paths $dirprev[-1..1] \
               $dirnext[-1..1] \
               (find "$dir" -maxdepth 1 -mindepth 1 -type d)

  for p in $paths;
    set p (string replace "$dir/" "" "$p")
    or continue # not a subdirectory
    and set b (string split / "$p")[1] # get first component

    contains "$b" $branches
    or begin
      set -a branches "$b"
      echo "$b"
    end
  end
end
