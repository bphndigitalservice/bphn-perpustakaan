#!/bin/sh
set -e

# Make sure directories exist
mkdir -p /app/config
mkdir -p /app/files
mkdir -p /app/images
mkdir -p /app/repository

# Set proper ownership for security
chown -R application:application /app/config
chown -R application:application /app/files
chown -R application:application /app/images
chown -R application:application /app/repository

chmod -R 777 /app/config
chmod -R 777 /app/files
chmod -R 777 /app/images
chmod -R 777 /app/repository
