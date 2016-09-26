#!/bin/bash
# Startup wrapper for Docker containers
source /etc/apache2/envvars

# Check if /data/data.db exists.  If not, run
# the migration/setup tools
if [[ ! -e "/data/data.db" ]]; then
  sqlite3 /data/data.db < /var/www/411/db.sql
  /var/www/411/bin/migration.php
  /var/www/411/bin/create_site.php
  /var/www/411/bin/create_user.php
fi

# Apache needs to run in the foreground for daemon containers
/usr/sbin/apache2 -DFOREGROUND
