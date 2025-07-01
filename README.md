SLiMS 9 Bulian
===============
SENAYAN Library Management System (SLiMS) version 9 Codename Bulian

SLiMS is free open source software for library resources management
(such as books, journals, digital document and other library materials)
and administration such as collection circulation, collection management,
membership, stock taking and many other else.

SLiMS is licensed under GNU GPL version 3. Please read "GPL-3.0 License.txt"
to learn more about GPL.

### System Requirements
- PHP version >= 8.1;
- MySQL version 5.7 and or MariaDB version 10.3;
- PHP GD enabled
- PHP gettext enabled
- PHP mbstring enabled

### Docker Support
SLiMS can be run using Docker. A `Dockerfile` and `docker-compose.yml` are provided in the repository.

To run SLiMS using Docker Compose:
```bash
docker-compose up -d
```

This will start both the SLiMS application and a MariaDB database.

#### Volume Permissions
The Docker setup ensures that mounted volumes (`./files`, `./images`, `./repository`, and `./config`) have bidirectional write access, allowing both the container and the host to read and write files. This is achieved through:

1. Setting appropriate ownership (apache:apache) inside the container
2. Using permissive file permissions (775 for directories, 664 for files)

This configuration is particularly useful for development environments where you need to edit files on the host while the container is running.

### GitHub Actions Workflow
This repository includes a GitHub Actions workflow that automatically builds and publishes Docker images to GitHub Container Registry (ghcr.io) when:

- Code is pushed to the main/master branch
- A new tag is created (starting with 'v', e.g., 'v9.6.1')
- A pull request is opened against the main/master branch (image is built but not pushed)

The published images are available at:
```
ghcr.io/[OWNER]/[REPOSITORY]:[TAG]
```

For more details, see the [GitHub Actions workflow documentation](.github/workflows/README.md).
