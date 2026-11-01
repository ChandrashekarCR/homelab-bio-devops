#!/usr/bin/env bash

# Show progess: XP, level, progress bar and commit streak
# Reads PROGESS.md

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
file="${1:-PROGRESS.md}"
[[ -f "$file" ]] ||{ echo "no $file here" >&2; exit 1; }

sum_xp() {
    # grep exits 1 when nothing matches; under pipefail and the would abort the script
    { grep -E "$1" "$file" || true; } | { grep -oE '[0-9]+ XP' || true; } | awk '{s += $1} END {print s + 0}'
}


earned_xp=$(sum_xp '^[[:space:]]*- \[[xX]\]' )
total=$(sum_xp '^[[:space:]]*- \[[ xX]\]')
# level thresholds: "xp:name"
levels=("0:Tinkerer" "400:Apprentice Sysadmin" "900:Network Wrangler" "1500:Service Builder" "2200:Reliability Guardian" "3000:Team-Ready Engineer")
level=1 name="" next=""
for i in "${!levels[@]}"; do
    min=${levels[$i]%%:*}
    if (( earned_xp >= min )); then
        level=$((i + 1)); name=${levels[$i]#*:}
        next=${levels[$((i + 1))]:-}
    fi
done

# 30 character bar
width=30 filled=0
width=30 filled=0
(( total > 0 )) && filled=$(( earned_xp * width / total ))
bar=$(printf '%*s' "$filled" '' | tr ' ' '#')$(printf '%*s' $((width - filled)) '' | tr ' ' '.')

# streak: consecutive days (ending today or yesterday) with at least one commit
streak=0
mapfile -t days < <(git log --format=%ad --date=short 2>/dev/null | sort -ur)
if (( ${#days[@]} > 0 )); then
  expect=$(date +%F)
  [[ "${days[0]}" == "$expect" ]] || expect=$(date -d yesterday +%F)
  for d in "${days[@]}"; do
    [[ "$d" == "$expect" ]] || break
    streak=$((streak + 1))
    expect=$(date -d "$d - 1 day" +%F)
  done
fi

printf 'Level %d - %s\n' "$level" "$name"
printf '[%s] %d / %d XP\n' "$bar" "$earned_xp" "$total"
if [[ -n "$next" ]]; then
  printf 'Next: %s in %d XP\n' "${next#*:}" $(( ${next%%:*} - earned_xp ))
else
  printf 'Max level. Go update your CV.\n'
fi
printf 'Streak: %d day(s)\n' "$streak"
