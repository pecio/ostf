#!/bin/bash
if [ -e /dev/vdb ]
then
    echo STOPPING MARIADB
    systemctl stop mariadb
    echo "/dev/vdb /var/lib/mysql ext4 defaults 0 0" >> /etc/fstab
    mount /var/lib/mysql

    if (( $? != 0 ))   # mount failed
    then
        mkfs -t ext4 /dev/vdb
        mount /var/lib/mysql
    fi

    # Fix ownership and SELinux label of /var/lib/mysql
    chown mysql:mysql /var/lib/mysql/

    echo RESTARTING MARIADB
    systemctl start mariadb
fi

curl -O http://169.254.169.254/openstack/latest/meta_data.json
db_name="$(jq -r .meta.db_name meta_data.json)"
db_user="$(jq -r .meta.db_user meta_data.json)"
db_pass="$(jq -r .meta.db_pass meta_data.json)"

mysqladmin -u root password "${db_pass}"
mysqladmin create "${db_name}" -u root -p"${db_pass}"
mysql -D mysql -u root -p"${db_pass}" -e \
  "GRANT ALL PRIVILEGES ON ${db_name}.* \
  TO '${db_user}'@'%'                   \
  IDENTIFIED BY '${db_pass}'; FLUSH PRIVILEGES;"
