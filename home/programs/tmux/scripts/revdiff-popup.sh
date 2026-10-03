tmp=$(mktemp)
revdiff -o "$tmp"
[ -s "$tmp" ] && "${EDITOR:-nvim}" "$tmp"
rm -f "$tmp"
