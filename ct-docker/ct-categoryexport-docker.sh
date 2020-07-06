#!/bin/bash

echo "*************************************"
echo "*******Generating Access Token*******"
echo "*************************************"

accesstoken=$(curl https://auth.europe-west1.gcp.commercetools.com/oauth/token -X POST --basic --user "$clientid:$clientsecret" -d "grant_type=client_credentials&scope=manage_project:$@" | awk -F',' '{print $1}' | awk -F':' '{print $2}')

echo "*************************************"
echo "***Exporting Commercetools category***"
echo "*************************************"

#TIMESTAMP=$(date "+%Y.%m.%d-%H.%M.%S")
OutputFile="/opt/ct-data/$@_category.csv"

docker run --rm --name commercetools -v /opt/ct-data/:/opt/ct-data/ commercetools:latest category-exporter --projectKey $@ --apiUrl https://api.sphere.io --authUrl https://auth.sphere.io --accessToken $accesstoken --output $OutputFile

#aws s3 cp $OutputFile  s3://ct-backuptest/data_$TIMESTAMP.zip --profile FOODL-DEVMFA > /dev/null 2>&1
