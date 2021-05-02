#!/bin/bash -e

RDF_TYPE=$1
[[ ${RDF_TYPE:?} = *[[:space:]]* ]] && exit 1

table_dump=$(curl -sS -L https://api-tokyochallenge.odpt.org/api/v4/odpt:$RDF_TYPE.json?acl:consumerKey=${ACL_CONSUMERKEY:?} | jq -c ".[]")
table_name=${RDF_TYPE,,}

echo "CREATE TABLE IF NOT EXISTS ${table_name} (data jsonb NOT NULL);"
echo "CREATE UNIQUE INDEX ON ${table_name} ((data->>'owl:sameAs'));"
echo "TRUNCATE TABLE ${table_name};"

IFS=$'\n'
for data in ${table_dump}
do
  echo "INSERT INTO ${table_name} VALUES ('${data}'::jsonb);"
done
