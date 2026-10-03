tmux wait -L pane_wait
hook_pane=$1
# Parent pane exited - clean up its floating session if exists
if [[ -n "$hook_pane" ]]; then
  floating_name="floating_pane_$hook_pane"
  tmux kill-session -t "$floating_name" 2>/dev/null
fi
tmux wait -U pane_wait
