!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <factname>"
  echo "# Lists all possible values for a fact"
  exit 64;
fi;

fact="$1"

curl -Gs "http://localhost:8080/pdb/query/v4/fact-contents" \
  --data-urlencode "query=["'"'"="'"'", "'"'"name"'"'", "'"'"${fact}"'"'"]" | \
  jq \
    'group_by(.value)
    | map({value: .[0].value, hosts: (map(.certname) | sort), count: length})
    | . as $groups
    | ($groups | map(.count) | add) as $total
    | $groups
    | map(. + {
        percentage: (
          ((.count * 10000) / $total)
          | floor / 100
        )
    })'

