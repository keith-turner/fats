#!/bin/bash

set -e

cd `ls -d $HOME/install/accumulo-*`
cd test/system/randomwalk/

cp conf/logger.xml.example conf/logger.xml
cp conf/randomwalk.conf.example conf/randomwalk.conf

sed -i '/ZOOKEEPERS=/d' conf/randomwalk.conf
sed -i '/INSTANCE=/d' conf/randomwalk.conf

echo ZOOKEEPERS=`grep io.fluo.client.accumulo.zookeepers= $HOME/install/fluo-cluster/conf/fluo.properties | cut -f 2 -d =` >> conf/randomwalk.conf
echo INSTANCE=`grep io.fluo.client.accumulo.instance= $HOME/install/fluo-cluster/conf/fluo.properties | cut -f 2 -d =` >> conf/randomwalk.conf

sed -i 's/\(.*edge.*id="Security.xml".*\)/<!-- \1  -->/' conf/modules/All.xml

sed -i 's/\(.*edge.*id="ct.CheckBalance".*\)/<!-- \1  -->/' conf/modules/Concurrent.xml

cp ../../../conf/slaves conf/walkers

sudo yum -y install pssh

