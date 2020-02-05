function fish_right_prompt -d "Write out the right prompt"
  # Use the right prompt for warnings

  # If logged in on a TTY
  if w | egrep -q " tty[0-9]+ " ;
    echo (set_color --bold red)TTY(set_color normal)
  end

  return 0
end
