#!/bin/bash

cd `ls -d /home/ec2-user/install/accumulo-*`
cd test/system/continuous/

./stop-ingest.sh
rm continuous-env.sh
../../../bin/accumulo shell -u root -p secret -e 'deletetable -f ci'
