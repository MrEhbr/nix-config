# Usage: revdiff-toggle <pane_path> <current_session>
# Expects $revdiff_popup to hold the revdiff-popup executable path.
pane_path="$1"
current_session="$2"

repo=$(git -C "$pane_path" rev-parse --show-toplevel 2>/dev/null)
if [ -z "$repo" ]; then
  tmux display-message "revdiff: not in a git repo"
  exit 0
fi

slug=$(printf '%s' "$repo" | sed 's|[^A-Za-z0-9_-]|_|g')
session="revdiff_$slug"

if [ "$current_session" = "$session" ]; then
  tmux detach-client
else
  tmux display-popup -d "$repo" -w95% -h95% -E "tmux new-session -A -s $session 'tmux set status off; exec $revdiff_popup' ';' set detach-on-destroy on"
fi
