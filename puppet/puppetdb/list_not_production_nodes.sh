#!/bin/bash

curl -Gs -X GET http://localhost:8080/pdb/query/v4/nodes --data-urlencode 'query=["not", [ "=","catalog_environment", "production"]]' \
  | jq 'group_by(.catalog_environment)[] | {(.[0].catalog_environment): (reduce .[] as $item({}; . + {($item.certname): {status: ($item.latest_report_status // "unknown"), last_update: $item.catalog_timestamp}}))}'

