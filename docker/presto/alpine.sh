apk update && apk add openjdk8 python2 wget java-snappy-native

export PRESTO_VERSION=0.273.3

wget -O presto.tar.gz https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz
mkdir -p /opt
tar -xf presto.tar.gz -C /opt
rm presto.tar.gz
mv /opt/presto-server-${PRESTO_VERSION} /opt/presto
ls -1 /opt/presto/plugin/ | grep -v hive-hadoop2 | xargs -I{} rm -r /opt/presto/plugin/{}
