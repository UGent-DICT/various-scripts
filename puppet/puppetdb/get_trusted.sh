#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <nodename>"
  echo "# Returns the trusted facts of a node"
  exit 64;
fi;

curl -Gs http://localhost:8080/pdb/query/v4/facts/trusted --data-urlencode "query=[\"=\", \"certname\", \"${1}\"]" | jq '.[].value.extensions'
