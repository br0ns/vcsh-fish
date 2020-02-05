# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD 2> /dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty 2> /dev/null)
end

function fish_prompt
  set -l last_status $status

  set -l magenta (set_color magenta)
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l lgray (set_color --dim white)
  set -l dgray (set_color brblack)

  set -l bmagenta (set_color --bold magenta)
  set -l bcyan (set_color --bold cyan)
  set -l byellow (set_color --bold yellow)
  set -l bred (set_color --bold red)
  set -l bblue (set_color --bold blue)
  set -l bgreen (set_color --bold green)
  set -l blgray (set_color --bold --dim white)
  set -l bdgray (set_color --bold brblack)

  set -l normal (set_color normal)

  # Make variable local
  set -l cwd ""

  # Print a heart if in home dir, otherwise replace by ~
  if test "$PWD" = "$HOME";
    set cwd "("$bred"♥"$normal")";
  else if test "$PWD" = "/";
    set cwd "("$bred"⊥"$normal")";
  else
    set cwd (pwd | sed "s:^$HOME:~:");

    # Add level markers to parent dirs (for .n-functions)
    set -l xs (string split '/' "$cwd")
    set cwd ""
    set -l len (count $xs)
    set -l max 5
    set -l i 1
    for x in $xs;
      # Dir is `d` levels up
      set -l d (math $len - $i)
      if test $d -gt 0;
        set cwd "$cwd$bblue$x"
        if test $d -le $max;
          set cwd "$cwd$normal$yellow/$d "
          # set cwd "$cwd$normal$yellow/"(string repeat -n (math $d + 1) .)" "
        else
          set cwd "$cwd/"
        end
      else
        set cwd "$cwd$bgreen$x"
      end

      set i (math $i+1)
    end
  end

  # Output the prompt, left to right

  # # Add a newline before new prompts
  # echo -e ''

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Print pwd or full path
  echo -n -s $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '(' $yellow $git_branch "±" $normal ')'
    else
      set git_info '(' $green $git_branch $normal ')'
    end
    echo -n -s ' · ' $git_info $normal
  end

  set -l prompt_color $red
  if test $last_status = 0
    set prompt_color $normal
  end

  # # Show dir branches
  # # TODO: skip deleted dirs
  # # TODO: push .-dirs to end of list (except if recently visited)
  # set -l max_width 50
  # set -l bs (dir-branches)
  # set -l len (count $bs)
  # set -l n 0
  # set -l sep ""

  # __dir-branch-init
  # if test $dir_branch_idx -ne 1

  #   while test $dir_branch_idx -gt $len
  #     set dir_branch_idx (math $dir_branch_idx - $len)
  #   end

  #   while test $dir_branch_idx -lt 1
  #     set dir_branch_idx (math $dir_branch_idx + $len)
  #   end

  #   set bs $bs[$dir_branch_idx..-1] \
  #          $bs[1..(math $dir_branch_idx - 1)]
  # end

  # if test -n "$bs"
  #   echo -en " "$lgray"["$blgray
  #   for b in $bs
  #     set -l n_ (math $n + (string length "$b"))
  #     if test $n_ -gt $max_width -a $n -gt 0
  #       echo -n $normal$lgray"|..."
  #       break
  #     end

  #     echo -n $sep$b$normal$lgray

  #     set n $n_
  #     set sep "|"
  #   end
  #   echo -n "]"
  # end

  # Terminate with a nice prompt char
  echo -e '\e[K' # XXX: Clear line, why is this needed?
  # echo -e ''
  echo -e -n -s $prompt_color '⟩ ' $normal
end
