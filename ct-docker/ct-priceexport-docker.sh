#!/bin/bash

echo "*************************************"
echo "*******Generating Access Token*******"
echo "*************************************"

if [ $@ = foodl-dev-36 ]
then
    accesstoken=$(curl https://auth.europe-west1.gcp.commercetools.com/oauth/token -X POST --basic --user "${dev_clientid}:${dev_clientsecret}" -d "grant_type=client_credentials&scope=manage_project:$@" | awk -F',' '{print $1}' | awk -F':' '{print $2}')
elif [ $@ = foodl-prod-1 ]
then
    accesstoken=$(curl https://auth.europe-west1.gcp.commercetools.com/oauth/token -X POST --basic --user "${prod_clientid}:${prod_clientsecret}" -d "grant_type=client_credentials&scope=manage_project:$@" | awk -F',' '{print $1}' | awk -F':' '{print $2}')       
else
    accesstoken=$(curl https://auth.europe-west1.gcp.commercetools.com/oauth/token -X POST --basic --user "${acc_clientid}:${acc_clientsecret}" -d "grant_type=client_credentials&scope=manage_project:$@" | awk -F',' '{print $1}' | awk -F':' '{print $2}')
fi

echo "*************************************"
echo "***Exporting Commercetools Price***"
echo "*************************************"

#TIMESTAMP=$(date "+%Y.%m.%d-%H.%M.%S")
OutputFile="/opt/ct-data/$@_price.csv"



docker run --rm --name commercetools -v /opt/ct-data/:/opt/ct-data/ commercetools:latest price-exporter --projectKey $@ --apiUrl https://api.sphere.io --authUrl https://auth.sphere.io --accessToken $accesstoken --output $OutputFile

#aws s3 cp $OutputFile  s3://ct-backuptest/data_$TIMESTAMP.zip --profile FOODL-DEVMFA > /dev/null 2>&1
