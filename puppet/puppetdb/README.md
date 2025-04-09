# puppetdb scripts

Scripts that query the puppetdb api for information.

## Requirements

* curl
* jq

## Scripts

### fact_values.sh

Lists all possible values for a fact.

Usage: `fact_values.sh <fact_name>`

#### Examples

##### List all values with hosts and usage (count/percentage)

`./fact_values.sh apache_version`

Output:

```json
[
  {
    "value": "2.4.25",
    "hosts": [...],
    "count": 4,
    "percentage": 0.67
  },
  {
    "value": "2.4.37",
    "hosts": [...],
    "count": 25,
    "percentage": 4.2
  },
  {
    "value": "2.4.6",
    "hosts": [...],
    "count": 49,
    "percentage": 8.24
  },
  {
    "value": "2.4.62",
    "hosts": [...],
    "count": 516,
    "percentage": 86.86
  }
]
```

##### List all values only

`./fact_values.sh apache_version | jq .[].value`

Output:

```
"2.4.25"
"2.4.37"
"2.4.6"
"2.4.62"
```
