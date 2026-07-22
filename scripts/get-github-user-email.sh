#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <github-user>" >&2
  exit 1
fi

account="$1"
data=$(curl -fsSL "https://api.github.com/users/$account" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0')
id=$(jq --raw-output '.id' <<<"$data")
name=$(jq --raw-output '.name // .login' <<<"$data")

printf "Co-authored-by: %s <%s+%s@users.noreply.github.com>\n" "$name" "$id" "$account" | pbcopy
printf "Co-authored-by: %s <%s+%s@users.noreply.github.com>\n" "$name" "$id" "$account"
