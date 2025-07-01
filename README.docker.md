# Docker Setup for SLiMS 9 Bulian

This document explains how to deploy SLiMS 9 Bulian using Docker and Docker Compose.

## Requirements

- Docker Engine
- Docker Compose

## Quick Start

1. Clone the repository or download the SLiMS 9 Bulian source code.
2. Navigate to the SLiMS directory containing the Dockerfile and docker-compose.yml.
3. Run the following command to start the containers:

```bash
docker-compose up -d
```

4. Access SLiMS in your browser at http://localhost

## Configuration

The Docker setup includes:

- A web container running PHP 8.1 with Apache
- A MariaDB 10.6 database container
- Persistent volumes for database data and SLiMS files

### Environment Variables

You can modify the following environment variables in the docker-compose.yml file:

- `DB_HOST`: Database hostname (default: db)
- `DB_PORT`: Database port (default: 3306)
- `DB_NAME`: Database name (default: slims)
- `DB_USER`: Database username (default: slims)
- `DB_PASSWORD`: Database password (default: slims_password)
- `MYSQL_ROOT_PASSWORD`: MariaDB root password (default: root_password)

## Installation

When you access SLiMS for the first time, you'll be redirected to the installation page. Follow these steps:

1. Select your language
2. The database connection should be pre-configured, but verify the settings:
   - Host: db
   - Port: 3306
   - Database Name: slims
   - Username: slims
   - Password: slims_password
3. Complete the installation by following the on-screen instructions

## Volumes

The following volumes are created for data persistence:

- `./files`: SLiMS files directory
- `./images`: SLiMS images directory
- `./repository`: SLiMS repository directory
- `./config`: SLiMS configuration directory
- `slims_db_data`: MariaDB data directory

## Customization

You can customize the Docker setup by modifying the Dockerfile and docker-compose.yml files according to your needs.

## Security Best Practices

This Docker setup follows security best practices for file permissions:

### File Permissions

- All application files are owned by the `www-data` user (Apache's user)
- Directory permissions are set to 750 (rwxr-x---) for writable directories:
  - Owner (www-data): read, write, execute
  - Group: read, execute
  - Others: no access
- File permissions are set to 640 (rw-r-----) for files in writable directories:
  - Owner (www-data): read, write
  - Group: read
  - Others: no access
- Configuration files with sensitive information (like database.php) have restricted permissions

These permission settings provide a balance between security and functionality, ensuring that:
- The web server can read and write files as needed
- Other users on the system cannot access sensitive data
- The principle of least privilege is followed

## Troubleshooting

If you encounter any issues:

1. Check the container logs:
```bash
docker-compose logs
```

2. Ensure all required directories have proper permissions.

3. If the database connection fails, you may need to wait a few moments for the database to initialize fully.

4. If you encounter GPG errors like "GPG error: http://deb.debian.org/debian InRelease: At least one invalid signature was encountered":
   - The Dockerfile has been updated to properly handle Debian repository GPG keys
   - If you still encounter issues, you may need to update the GPG keys manually:
     ```bash
     docker exec -it slims_app apt-get update || \
     docker exec -it slims_app bash -c "apt-get install -y gnupg dirmngr ca-certificates && \
     mkdir -p /etc/apt/keyrings && \
     curl -fsSL https://deb.debian.org/debian/dists/bookworm/Release.gpg | gpg --dearmor -o /etc/apt/keyrings/debian-archive-bookworm-stable.gpg && \
     echo 'deb [signed-by=/etc/apt/keyrings/debian-archive-bookworm-stable.gpg] http://deb.debian.org/debian bookworm main' > /etc/apt/sources.list.d/debian-bookworm.list && \
     apt-get update"
     ```
