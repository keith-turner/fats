#!/bin/bash

set -e

cd `ls -d /home/ec2-user/install/accumulo-*`
cd test/system/continuous/

if [ -f "continuous-env.sh" ]; then 
  echo "ERROR continuous-env.sh exists"
  exit 1
fi

cp continuous-env.sh.example continuous-env.sh.tmp

sed -i '/ACCUMULO_HOME=/d' continuous-env.sh.tmp
sed -i '/HADOOP_HOME=/d' continuous-env.sh.tmp
sed -i '/ZOOKEEPER_HOME=/d' continuous-env.sh.tmp
sed -i '/USER=/d' continuous-env.sh.tmp
sed -i '/PASS=/d' continuous-env.sh.tmp
sed -i '/VERIFY_MAX_MAPS=/d' continuous-env.sh.tmp
sed -i '/ZOO_KEEPERS=/d' continuous-env.sh.tmp

echo ACCUMULO_HOME=`ls -d /home/ec2-user/install/accumulo-*` >> continuous-env.sh
echo HADOOP_HOME=`ls -d /home/ec2-user/install/hadoop-*` >> continuous-env.sh
echo ZOOKEEPER_HOME=`ls -d /home/ec2-user/install/zookeeper-*` >> continuous-env.sh
echo USER=root >> continuous-env.sh
echo PASS=secret  >> continuous-env.sh
echo VERIFY_MAX_MAPS=4096 >> continuous-env.sh
echo ZOO_KEEPERS=`grep io.fluo.client.accumulo.zookeepers= /home/ec2-user/install/fluo-cluster/conf/fluo.properties | cut -f 2 -d =` >> continuous-env.sh

cat continuous-env.sh.tmp >> continuous-env.sh

rm continuous-env.sh.tmp

cp ../../../conf/slaves ingesters.txt

NUM_TABLETS=$(( 2 * $(wc -l ingesters.txt | cut -f 1 -d ' ') ))
../../../bin/accumulo org.apache.accumulo.test.continuous.GenSplits $NUM_TABLETS > splits.txt
../../../bin/accumulo shell -u root -p secret -e 'createtable ci'
../../../bin/accumulo shell -u root -p secret -e 'addsplits -t ci -sf splits.txt'

rm splits.txt
