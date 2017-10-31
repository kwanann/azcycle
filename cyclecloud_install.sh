#! /bin/bash

yum install -y java-1.8.0-openjdk wget
download_uri=$1
cycle_root=/opt/cycle_server

rm -rf /tmp/cycle_dl_dir
mkdir -p /tmp/cycle_dl_dir

pushd /tmp/cycle_dl_dir
wget $download_uri/cycle_server-all-6.6.0-linux64.tar.gz
wget $download_uri/pogo-cli-3.6.0.linux64.tar.gz
wget $download_uri/cyclecloud-cli-6.6.0.linux64.tar.gz

tar xf cyclecloud-cli-6.6.0.linux64.tar.gz
mv cyclecloud /usr/local/bin
tar xf pogo-cli-3.6.0.linux64.tar.gz
mv pogo /usr/local/bin
tar xf cycle_server-all-6.6.0-linux64.tar.gz
pushd cycle_server
./install.sh --nostart

# Increase the webserver heapsize by default
sed -i 's/webServerMaxHeapSize\=2048M/webServerMaxHeapSize\=4096M/' $cycle_root/config/cycle_server.properties
# Change 8080 and 8443 to 80 and 443. Enable HTTPS.
sed -i 's/webServerPort\=8080/webServerPort\=80/' $cycle_root/config/cycle_server.properties
sed -i 's/webServerSslPort\=8443/webServerSslPort\=443/' $cycle_root/config/cycle_server.properties
sed -i 's/webServerEnableHttps\=false/webServerEnableHttps=true/' $cycle_root/config/cycle_server.properties

# Generate self-signed SSL cert, add to CycleCloud server keystore
randomPW=$(strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 12 | tr -d '\n'; echo)
/bin/keytool -genkey -alias CycleServer -keypass "$randomPW" -keystore $cycle_root/.keystore  -storepass "$randomPW" -keyalg RSA -noprompt -dname "CN=cycleserver.azure.com,OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown"
chown cycle_server. $cycle_root/.keystore
chmod 600 $cycle_root/.keystore
sed -i "s/webServerKeystorePass\=changeit/webServerKeystorePass\=$randomPW/" $cycle_root/config/cycle_server.properties

# Start the CycleCloud server, wait for startup to complete before exiting.
$cycle_root/cycle_server start
$cycle_root/cycle_server await_startup
$cycle_root/cycle_server status

# cleanup
popd
rm -rf cycle_server
popd
rm -rf /tmp/cycle_dl_dir
