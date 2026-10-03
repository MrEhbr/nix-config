# Abbreviate path: replace $HOME with ~, optionally truncate deep paths
# Usage: abbreviate-path <path> [full]
# If second arg is "full", shows complete path (no truncation)
path="$1"
path="${path/#$HOME/\~}"
if [ "$2" = "full" ]; then
  echo "$path"
else
  IFS='/' read -ra parts <<<"$path"
  count=${#parts[@]}
  if [ "$count" -gt 4 ]; then
    echo "…/${parts[-3]}/${parts[-2]}/${parts[-1]}"
  else
    echo "$path"
  fi
fi
