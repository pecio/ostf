#!/bin/bash

curl -O http://169.254.169.254/openstack/latest/meta_data.json
db_name="$(jq -r .meta.db_name meta_data.json)"
db_user="$(jq -r .meta.db_user meta_data.json)"
db_pass="$(jq -r .meta.db_pass meta_data.json)"
db_addr="$(jq -r .meta.db_addr meta_data.json)"

cd /var/tmp
curl https://wordpress.org/latest.tar.gz | tar xzf -

mkdir /var/www/html/blog
cp -r wordpress/* /var/www/html/blog

cd /var/www/html/blog
mv wp-config-sample.php wp-config.php
sed -i -e "s/database_name_here/${db_name}/" \
  -e "s/username_here/${db_user}/" \
  -e "s/password_here/${db_pass}/" \
  -e "s/localhost/${db_addr}/" \
  wp-config.php
