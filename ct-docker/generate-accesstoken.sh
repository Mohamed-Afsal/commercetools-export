#!/bin/bash

echo "*************************************"
echo "*******Generating Access Token*******"
echo "*************************************"



curl https://auth.europe-west1.gcp.commercetools.com/oauth/token -X POST --basic --user "$clientid:$clientsecret" -d "grant_type=client_credentials&scope=manage_project:$@" | awk -F',' '{print $1}' | awk -F':' '{print $2}'

