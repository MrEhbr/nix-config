{
  programs.fish.functions = {
    exit_fn = ''
      if test -n "$TMUX_POPUP_OWNER"; and test "$fish_pid" = "$TMUX_POPUP_OWNER"
        set -l session_name (tmux display-message -p '#S')
        set -l pane_count (tmux list-panes | wc -l)
        if test $pane_count -eq 1
          tmux detach-client
          tmux kill-session -t $session_name
        else
          builtin exit
        end
      else
        builtin exit
      end
    '';

  };
}
