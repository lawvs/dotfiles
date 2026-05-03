#!/bin/bash

account=$1
data=$(curl -s https://api.github.com/users/$account -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36 Edg/136.0.0.0')
id=$(echo $data | jq .id)
name=$(echo $data | jq --raw-output '.name // .login')

printf "Co-authored-by: %s <%d+%s@users.noreply.github.com>\n" "$name" $id $account | pbcopy
printf "Co-authored-by: %s <%d+%s@users.noreply.github.com>\n" "$name" $id $account
