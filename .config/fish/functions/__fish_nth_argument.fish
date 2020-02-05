function __fish_nth_argument
  set -l cmd (commandline -poc) (commandline -ct)
  test (count $cmd) -eq (math $argv[1] + 1)
end
