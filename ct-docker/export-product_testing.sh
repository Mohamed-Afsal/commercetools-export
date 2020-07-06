#!/bin/bash

echo "Taking commercetool backup"
OutputFile="/MC/ct-test/sphere-node-product-csv-sync/tests/product.zip"

TIMESTAMP=$(date "+%Y.%m.%d-%H.%M.%S")

product-csv-sync export --projectKey xxxxxxxxxxxx --clientId xxxxxxxxxxxxxxx --clientSecret xxxxxxxxxxxxxx --fullExport --out $OutputFile > /dev/null 2>&1

#yes | unzip -q $OutputFile -d /MC/ct-test/sphere-node-product-csv-sync/tests/product > /dev/null 2>&1


#aws s3 cp /MC/ct-test/sphere-node-product-csv-sync/tests/product/*  s3://ct-backuptest/data_$TIMESTAMP.csv --profile FOODL-DEVMFA 
> /dev/null 2>&1

aws s3 cp $OutputFile  s3://ct-backuptest/data_$TIMESTAMP.zip --profile xxxxxxxx > /dev/null 2>&1

exit_status=$?
