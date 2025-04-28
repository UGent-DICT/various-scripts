#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <structured_fact> <value>"
  echo "# Returns all nodes that have a specific structured fact set to a specific value."
  exit 64;
fi;

PATH_QUERY="\"$(sed 's/\./", "/g' <<< "${1}")\""

curl -Gs http://localhost:8080/pdb/query/v4/fact-contents --data-urlencode "query=[\"extract\", \"certname\", [\"and\", [\"=\", \"path\", [${PATH_QUERY}]], [\"=\", \"value\", \"${2}\"]]]" | jq
