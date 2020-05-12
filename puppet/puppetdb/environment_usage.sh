#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <environment name>"
  echo "# Lists all nodes that a given environment."
  echo "# We replace all forward slashes with double underscores in the"
  echo "# environment name for git branch <-> puppet env compatibility."
  exit 64;
fi;

translate_env() {
  echo "${1}" | sed 's@/@__@g'
}

env=$( translate_env "$1" )

curl -Gs http://localhost:8080/pdb/query/v4/nodes --data-urlencode 'query=[ "=","catalog_environment", "'${env}'"]' | \
  jq '.[].certname'

