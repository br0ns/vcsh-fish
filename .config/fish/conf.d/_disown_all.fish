function _disown_all --on-event fish_prompt \
                     --description "Disown all jobs on exit"
  jobs -q
  and disown (jobs -p)
end
