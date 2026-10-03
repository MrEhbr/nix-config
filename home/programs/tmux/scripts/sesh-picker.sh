result=$(sesh list -tdc -H --icons | fzf \
  --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
  --header '^a all  ^t tmux  ^g zoxide  ^d tmux kill' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list -tdc -H --icons)' \
  --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -td -H --icons)' \
  --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -zd -H --icons)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list -tdc -H --icons)' \
  --preview-window 'right:60%:border-left' \
  --preview 'sesh preview {}')
[ -n "$result" ] && sesh connect "$result"
