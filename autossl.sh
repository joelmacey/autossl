#!/bin/bash
read -p "Enter site: " site
passphrase='test'

echo 'Making SSL Certificate for' $site
#Creates .key
openssl genrsa -des3 -out $site.key -passout pass:$passphrase 2048
# Creates key.pem & cert.pem
openssl req -x509 -newkey rsa:2048 -passin pass:$passphrase -days 300 -subj "/C=AU/ST=Victoria/L=Melbourne/O=Company/OU=IT Department/CN=$site" -keyout key.pem -out cert.pem  -passout pass:$passphrase 
#Creates .key.insecure
openssl rsa -passin pass:$passphrase -in $site.key -out $site.key.insecure 
#Creates .key.secure
mv $site.key $site.key.secure
#Creates .key
mv $site.key.insecure $site.key
#Creates .csr
openssl req -new -passin pass:$passphrase -subj "/C=AU/ST=Victoria/L=Melbourne/O=Company/CN=$site" -key $site.key -out $site.csr 
#Creates .crt
openssl x509 -req -passin pass:$passphrase -days 3650 -in $site.csr -signkey $site.key -out $site.crt 

#clean up & copy all cert files to the right dir
sudo rm *.pem
sudo rm *.csr
sudo rm *.key.secure
mkdir -p /etc/apache2/certs/
mv $site.* /etc/apache2/certs/
echo 'Certificates Created successfully for' $site