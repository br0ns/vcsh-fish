begin
    set --local AUTOJUMP_PATH /usr/share/autojump/autojump.fish
    if test -e $AUTOJUMP_PATH
        source $AUTOJUMP_PATH
    end
end

# bind -k sr dir-ascend
# bind -k sf dir-descend
# bind -k sright dir-branch-next
# bind -k sleft dir-branch-prev
