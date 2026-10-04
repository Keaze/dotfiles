#!/usr/bin/env bash
# Claude Code statusLine — Catppuccin Mocha powerline, matches ~/.config/starship.toml
#  OS │ dir │ vcs (jj-starship) │ model·effort │ context │ limits │ cost  [cold cache]

export LC_NUMERIC=C   # de_DE would print 3,60 and reject "3.6" in printf
input=$(cat)

# --- One jq pass: every field becomes a shell var (empty if missing) ---
eval "$(jq -r '
  def n: if . == null then "" else tostring end;
  @sh "dir=\(.workspace.current_dir // .cwd // "" | n)",
  @sh "model=\(.model.display_name | n)",
  @sh "effort=\(.effort.level | n)",
  @sh "fast=\(.fast_mode | n)",
  @sh "ctx_pct=\(.context_window.used_percentage | n)",
  @sh "ctx_size=\(.context_window.context_window_size | n)",
  @sh "ctx_used=\(.context_window.current_usage | if . == null then "" else (.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens | tostring) end)",
  @sh "cost=\(.cost.total_cost_usd | n)",
  @sh "added=\(.cost.total_lines_added | n)",
  @sh "removed=\(.cost.total_lines_removed | n)",
  @sh "warm=\(.prompt_cache.warm | n)",
  @sh "five_pct=\(.rate_limits.five_hour.used_percentage | n)",
  @sh "five_reset=\(.rate_limits.five_hour.resets_at | n)",
  @sh "week_pct=\(.rate_limits.seven_day.used_percentage | n)"
' <<<"$input")"

# --- Catppuccin Mocha (24-bit) ---
crust="17;17;27"  red="243;139;168"  peach="250;179;135"  yellow="249;226;175"
green="166;227;161"  teal="148;226;213"  sapphire="116;199;236"
lavender="180;190;254"  mauve="203;166;247"  overlay="108;112;134"
arr=$'' cap=$''
reset=$'\e[0m'

# --- Powerline renderer: seg <bg> <text>; closes with `end` ---
prev=""
out=""
seg() {
  local bg=$1 text=$2
  if [ -n "$prev" ]; then
    out+=$'\e[48;2;'"$bg"$'m\e[38;2;'"$prev""m$arr"
  else
    out+=$'\e[38;2;'"$bg"$'m'
  fi
  out+=$'\e[48;2;'"$bg"$'m\e[38;2;'"$crust""m $text "
  prev=$bg
}
end() { [ -n "$prev" ] && out+="$reset"$'\e[38;2;'"$prev""m$cap$reset"; }

# threshold colour: green < 50 ≤ yellow < 80 ≤ red
level() {
  local p=${1%.*}
  if [ "${p:-0}" -ge 80 ]; then echo "$red"; elif [ "${p:-0}" -ge 50 ]; then echo "$yellow"; else echo "$green"; fi
}
human() { awk -v n="$1" 'BEGIN { if (n >= 1e6) printf (n % 1e6 ? "%.1fM" : "%dM"), n/1e6; else if (n >= 1e3) printf "%.0fk", n/1e3; else printf "%d", n }'; }

# --- Segments ---
seg "$red" $'\U000f08c7'

short="${dir/#$HOME/\~}"
IFS='/' read -ra parts <<<"$short"
n=${#parts[@]}
[ "$n" -gt 4 ] && short="…/${parts[n-3]}/${parts[n-2]}/${parts[n-1]}"
[ -n "$dir" ] && seg "$peach" "$short"

if [ -n "$dir" ] && command -v jj-starship >/dev/null; then
  vcs=$(jj-starship --cwd "$dir" --no-color --no-jj-prefix --no-git-prefix --truncate-name 24 2>/dev/null)
  [ -n "$vcs" ] && seg "$yellow" $''" $vcs"
fi

if [ -n "$model" ]; then
  m=$'\U000f06a9'" $model"
  [ -n "$effort" ] && m+=" · $effort"
  [ "$fast" = "true" ] && m+=" ⚡"
  seg "$lavender" "$m"
fi

if [ -n "$ctx_pct" ]; then
  c=$'\U000f035b'" $(printf '%.0f' "$ctx_pct")%"
  [ -n "$ctx_used" ] && [ -n "$ctx_size" ] && c+=" $(human "$ctx_used")/$(human "$ctx_size")"
  seg "$(level "$ctx_pct")" "$c"
fi

if [ -n "$five_pct" ]; then
  r="5h $(printf '%.0f' "$five_pct")%"
  if [ -n "$five_reset" ]; then
    left=$(( five_reset - $(date +%s) ))
    [ "$left" -gt 0 ] && r+=" ↻$(( left / 3600 ))h$(printf '%02d' $(( left % 3600 / 60 )))"
  fi
  [ -n "$week_pct" ] && r+=" · 7d $(printf '%.0f' "$week_pct")%"
  worst=$five_pct
  [ -n "$week_pct" ] && [ "${week_pct%.*}" -gt "${worst%.*}" ] && worst=$week_pct
  bgc=$mauve
  [ "${worst%.*}" -ge 80 ] && bgc=$red
  seg "$bgc" $'\U000f051f'" $r"
fi

if [ -n "$cost" ] && awk -v c="$cost" 'BEGIN { exit !(c > 0) }'; then
  s=$(printf '$%.2f' "$cost")
  [ "${added:-0}" != 0 ] || [ "${removed:-0}" != 0 ] && s+=" +${added:-0}/-${removed:-0}"
  seg "$teal" "$s"
fi

[ "$warm" = "false" ] && seg "$sapphire" "❄ cold cache"

end
printf '%s' "$out"
