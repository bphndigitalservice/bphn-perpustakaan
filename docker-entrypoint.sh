#!/bin/bash
set -e

# Wait for database to be ready
echo "Waiting for database to be ready..."
ATTEMPTS=0
MAX_ATTEMPTS=30
until mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1 || [ $ATTEMPTS -eq $MAX_ATTEMPTS ]; do
  ATTEMPTS=$((ATTEMPTS+1))
  echo "Waiting for database connection... ($ATTEMPTS/$MAX_ATTEMPTS)"
  sleep 1
done

if [ $ATTEMPTS -eq $MAX_ATTEMPTS ]; then
  echo "Database connection failed after $MAX_ATTEMPTS attempts. Exiting."
  exit 1
fi

echo "Database is ready!"

# Create database.php from sample if it doesn't exist
if [ ! -f /var/www/html/config/database.php ]; then
  echo "Creating database.php configuration file..."
  cp /var/www/html/config/database.sample.php /var/www/html/config/database.php

  # Replace placeholders with environment variables
  sed -i "s/_DB_HOST_/$DB_HOST/g" /var/www/html/config/database.php
  sed -i "s/_DB_NAME_/$DB_NAME/g" /var/www/html/config/database.php
  sed -i "s/_DB_PORT_/$DB_PORT/g" /var/www/html/config/database.php
  sed -i "s/_DB_USER_/$DB_USER/g" /var/www/html/config/database.php
  sed -i "s/_DB_PASSWORD_/$DB_PASSWORD/g" /var/www/html/config/database.php
  sed -i "s/_STORAGE_ENGINE_/InnoDB/g" /var/www/html/config/database.php

  echo "Database configuration created successfully!"
fi

# Make sure the directory permissions are correct - following security best practices
# Set ownership to www-data (Apache user)
chown -R www-data:www-data /var/www/html/files
chown -R www-data:www-data /var/www/html/images
chown -R www-data:www-data /var/www/html/repository
chown -R www-data:www-data /var/www/html/config

# Set secure permissions for writable directories
# 750 means: owner can read/write/execute, group can read/execute, others have no access
find /var/www/html/files -type d -exec chmod 750 {} \;
find /var/www/html/images -type d -exec chmod 750 {} \;
find /var/www/html/repository -type d -exec chmod 750 {} \;
find /var/www/html/config -type d -exec chmod 750 {} \;

# 640 means: owner can read/write, group can read, others have no access
find /var/www/html/files -type f -exec chmod 640 {} \;
find /var/www/html/images -type f -exec chmod 640 {} \;
find /var/www/html/repository -type f -exec chmod 640 {} \;
find /var/www/html/config -type f -exec chmod 640 {} \;

# Ensure database.php has restricted permissions if it exists
if [ -f /var/www/html/config/database.php ]; then
  chmod 640 /var/www/html/config/database.php
fi

# Execute the original command
exec "$@"
