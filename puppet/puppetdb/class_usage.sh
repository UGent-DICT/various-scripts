#!/bin/bash

if [ $# -eq 0 ]; then
  echo "USAGE: $0 <classname>"
  echo "# Lists all nodes that use a class"
  exit 64;
fi;

normalize_classname() {
  IFS="::"
  local class=( $1 )
  echo "${class[@]^}" | sed 's@\s\+@::@g'
}

class="$( normalize_classname "$1" )"

curl -Gs http://localhost:8080/pdb/query/v4/resources/Class/$class | jq '.[].certname'
