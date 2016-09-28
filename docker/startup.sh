#!/bin/bash
# Startup wrapper for Docker containers
source /etc/apache2/envvars

# Copy Docker's $HOSTNAME into $FOURONEONEHOST
export FOURONEONEHOST=$HOSTNAME

# Check if /data/data.db exists.  If not, run
# the migration/setup tools
if [[ ! -e "/data/data.db" ]]; then
  sqlite3 /data/data.db < /var/www/411/db.sql
  /var/www/411/bin/migration.php
  /var/www/411/bin/create_site.php
  /var/www/411/bin/create_user.php
fi
if [[ ! -e "/data/config.php" ]]; then
  cp -a /var/www/411/docker/config.php /data/config.php
fi
# Apache needs to run in the foreground for daemon containers
/usr/sbin/apache2 -DFOREGROUND
