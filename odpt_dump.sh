#!/bin/bash
RDF_TYPE=$1
[[ ${RDF_TYPE:?} = *[[:space:]]* ]] && exit 1

table_name=${RDF_TYPE,,}

echo "\\timing on"
echo "CREATE TABLE IF NOT EXISTS ${table_name} (data jsonb NOT NULL);"
echo "TRUNCATE TABLE ${table_name};"

IFS=$'\n'
for data in $(curl -sS -L https://api-tokyochallenge.odpt.org/api/v4/odpt:$RDF_TYPE.json?acl:consumerKey=$ACL_CONSUMERKEY | jq -c ".[]")
do
  echo "INSERT INTO ${table_name} VALUES ('${data}'::jsonb);"
done
