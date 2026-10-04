#!/bin/bash

# Read-only lab status. Prints one JSON object. Does not start a capture
# and does not change scope.md.

set -euo pipefail

home=${HOME:-}
work=${CYBER_LAB_WORK:-${home:+$home/Work}}

captures=()
for name in dumpcap tcpdump wireshark termshark; do
  if pgrep -x "$name" >/dev/null 2>&1; then
    captures+=("$name")
  fi
done

if ((${#captures[@]})); then
  cap_json=$(printf '%s\n' "${captures[@]}" | jq -R . | jq -s .)
else
  cap_json='[]'
fi

scope=""
authorized=false
if [[ -n $work && -d $work ]]; then
  latest=""
  shopt -s nullglob
  for file in "$work"/*/scope.md; do
    [[ -f $file ]] || continue
    if [[ -z $latest || $file -nt $latest ]]; then
      latest=$file
    fi
  done
  shopt -u nullglob
  if [[ -n $latest ]]; then
    scope=$latest
    if grep -Eq '^Authorized by:[[:space:]]*[^[:space:]]' "$latest"; then
      authorized=true
    fi
  fi
fi

jq -nc \
  --argjson captures "$cap_json" \
  --arg scope "$scope" \
  --argjson authorized "$authorized" \
  '{captures:$captures, scope:$scope, authorized:$authorized}'
