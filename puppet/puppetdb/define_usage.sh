#!/bin/bash

set -o errexit # exit on any command failure; use `whatever || true` to accept failures
               # use `if something; then` instead of `something; if [ $? -eq 0 ]; then`
               # use `rv=0; something || rv=$?` if you really need the exact exit code
set -o pipefail # pipes fail when any command fails, not just the last one. Use: ( whatever || true ) | somethingelse
set -o nounset # exit on use of undeclared var, use `${possibly_undefined-}` to substitute the empty string in that case
               # You can assign default values like this:
               # `: ${possibly_undefined=default}`
               # `: ${possibly_undefined_or_empty:=default}` will also replace an empty (but declared) value

# Option parsing & usage info
usage() {
  cat - <<EOHELP
USAGE:
  $0 <options> [resource name]

OPTIONS:
    -h, --help                This help message.
    -d, --detailed 						Display all resource information.
		-p, --parameters					Show defined resource parameters.
ARGUMENTS:
    A (puppet) defined type.

EOHELP
}

## getopt parsing
if `getopt -T >/dev/null 2>&1` ; [ $? = 4 ] ; then
  true; # Enhanced getopt.
else
  echo "Could not find an enhanced \`getopt\`. You have $(getopt -V)"
  exit 69 # EX_UNAVAILABLE
fi;

if GETOPT_TEMP="$( getopt -o hdp --long help,detailed,parameters -n "$0" -- "$@" )"; then
    eval set -- "${GETOPT_TEMP}"
else
    usage >&2
    exit 64
fi

DETAILED=0
PARAMETERS=0

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)       usage; exit 0;;
    -d|--detailed)   DETAILED=1;;
    -p|--parameters) PARAMETERS=1; shift;;   # Read in the (required) param, and shift it off (note the second 'shift' after this case block)
    --)            shift; break;;
    *)             break;;
  esac;
  shift;
done

if [ $# -lt 1 ]; then
    usage >&2
    exit 64 # EX_USAGE
fi

normalize_resource() {
  IFS="::"
  local class=( $1 )
  echo "${class[@]^}" | sed 's@\s\+@::@g'
}

resource="$( normalize_resource "$1" )"

if [ $DETAILED -eq 1 ]; then
  # Full Details
	curl -Gs http://localhost:8080/pdb/query/v4/resources/$resource | jq ' group_by(.certname)[] | {(.[0].certname): .[] }' | jq -s 'add'
elif [ $PARAMETERS -eq 1 ];then
  # Parameters only
  curl -Gs http://localhost:8080/pdb/query/v4/resources/$resource | jq ' group_by(.certname)[] | {(.[0].certname): [.[] | .parameters]}' | jq -s 'add'
else
  curl -Gs http://localhost:8080/pdb/query/v4/resources/$resource | jq ' group_by(.certname)[] | {(.[0].certname): [.[] | .title]}' | jq -s 'add'
fi

