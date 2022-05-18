#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <trusted_fact> <value>"
  echo "# Returns all nodes that have a specific trusted fact set to a specific value."
  exit 64;
fi;

curl -Gs http://localhost:8080/pdb/query/v4/inventory --data-urlencode "query=[\"extract\", [\"trusted.certname\"], [\"=\", \"trusted.extensions.${1}\", \"${2}\"]]" | jq 
