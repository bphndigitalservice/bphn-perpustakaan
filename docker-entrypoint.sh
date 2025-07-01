#!/bin/sh
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
chown -R apache:apache /app/config
chown -R apache:apache /app/files
chown -R apache:apache /app/images
chown -R apache:apache /app/repository

# Set proper permissions - directories and files writable by owner and group
# This ensures both the container and host can write to these directories
find /app/config -type d -exec chmod 775 {} \;
find /app/config -type f -exec chmod 664 {} \;
find /app/files -type d -exec chmod 775 {} \;
find /app/files -type f -exec chmod 664 {} \;
find /app/images -type d -exec chmod 775 {} \;
find /app/images -type f -exec chmod 664 {} \;
find /app/repository -type d -exec chmod 775 {} \;
find /app/repository -type f -exec chmod 664 {} \;
