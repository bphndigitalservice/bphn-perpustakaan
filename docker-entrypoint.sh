#!/bin/bash
set -e

# Set default umask to ensure new files have correct permissions
# 022 means new files will be created with 755 for dirs and 644 for files
umask 022

# Make sure directories exist
mkdir -p /app/config
mkdir -p /app/files
mkdir -p /app/images
mkdir -p /app/repository

# Set proper ownership for security
chown -R www-data:www-data /app/config
chown -R www-data:www-data /app/files
chown -R www-data:www-data /app/images
chown -R www-data:www-data /app/repository

# Set proper permissions - directories writable by owner, files readable
find /app/config -type d -exec chmod 755 {} \;
find /app/config -type f -exec chmod 644 {} \;
find /app/files -type d -exec chmod 755 {} \;
find /app/files -type f -exec chmod 644 {} \;
find /app/images -type d -exec chmod 755 {} \;
find /app/images -type f -exec chmod 644 {} \;
find /app/repository -type d -exec chmod 755 {} \;
find /app/repository -type f -exec chmod 644 {} \;

# Execute the command provided to the container
exec "$@"
