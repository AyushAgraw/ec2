#!/bin/bash

yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd

echo "Hello from $(hostname -f)" > /var/www/html/index.html

# Run below command to encode user-data using  base64
# base64 -w 0 Bash_script_name > base64.txt 
