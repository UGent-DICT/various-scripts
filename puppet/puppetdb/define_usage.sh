#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <define>"
  echo "# Lists all nodes that use a define with used titles."
  exit 64;
fi;

normalize_resource() {
  IFS="::"
  local class=( $1 )
  echo "${class[@]^}" | sed 's@\s\+@::@g'
}

resource="$( normalize_resource "$1" )"

curl -Gs http://localhost:8080/pdb/query/v4/resources/$resource | jq ' group_by(.certname)[] | {(.[0].certname): [.[] | .title]}' | jq -s 'add'

