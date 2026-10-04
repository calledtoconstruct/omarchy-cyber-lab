#!/bin/bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
empty=$(mktemp -d)
trap 'rm -rf "$work" "$empty"' EXIT

mkdir -p "$work/older" "$work/newer"
printf 'Authorized by:\n' >"$work/older/scope.md"
touch -d '2020-01-01 00:00:00' "$work/older/scope.md"
printf 'Authorized by: Ada\nIn scope: lab\n' >"$work/newer/scope.md"

out=$(CYBER_LAB_WORK="$work" "$root/status.sh")
jq -e --arg scope "$work/newer/scope.md" '
  .authorized == true and .scope == $scope and (.captures | type == "array")
' <<<"$out" >/dev/null

printf 'Authorized by:\n' >"$work/newer/scope.md"
out=$(CYBER_LAB_WORK="$work" "$root/status.sh")
jq -e --arg scope "$work/newer/scope.md" '
  .authorized == false and .scope == $scope
' <<<"$out" >/dev/null

out=$(CYBER_LAB_WORK="$empty" "$root/status.sh")
jq -e '.authorized == false and .scope == "" and (.captures | type == "array")' <<<"$out" >/dev/null

echo "ok - cyber lab status"
