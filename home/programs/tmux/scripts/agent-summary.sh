# Count windows tagged with @agent_state (set by ~/.claude/scripts/tmux-agent-state) and emit a
# tmux-styled "N working / N waiting / N idle" segment; groups at zero are
# omitted. Waiting blinks.
# Expects $color_working, $color_waiting and $color_idle to hold hex colors.
set -u
command -v tmux >/dev/null 2>&1 || exit 0

waiting=0
working=0
idle=0
while IFS= read -r s; do
  case "$s" in
    waiting) waiting=$((waiting + 1)) ;;
    working) working=$((working + 1)) ;;
    idle)    idle=$((idle + 1)) ;;
  esac
done < <(tmux list-windows -a -F '#{@agent_state}' 2>/dev/null)

out=""
sep() { [ -n "$out" ] && out="${out}  "; }
[ "$waiting" -gt 0 ] && { sep; out="${out}#[fg=${color_waiting},blink]● ${waiting} waiting#[noblink]"; }
[ "$working" -gt 0 ] && { sep; out="${out}#[fg=${color_working}]● ${working} working"; }
[ "$idle" -gt 0 ]    && { sep; out="${out}#[fg=${color_idle}]○ ${idle} idle"; }
[ -n "$out" ] && out="${out}#[default] "

printf '%s' "$out"
