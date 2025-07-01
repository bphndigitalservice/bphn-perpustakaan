# Docker Image GitHub Actions Workflow

This directory contains GitHub Actions workflow configurations for automatically building and publishing Docker images for the SLiMS project.

## Docker Image Workflow

The `docker-image.yml` workflow automatically builds and publishes Docker images to GitHub Container Registry (ghcr.io) when:

- Code is pushed to the `main` or `master` branch
- A new tag is created (starting with `v`, e.g., `v9.6.1`)
- A pull request is opened against the `main` or `master` branch (image is built but not pushed)

### Image Tags

The workflow automatically tags images with:

- Branch name (e.g., `main`, `develop`)
- Pull request number (for PRs)
- Version number (for tags, e.g., `v9.6.1`, `9.6`)
- Short commit SHA

### Using the Published Images

The published images are available at:

```
ghcr.io/[OWNER]/[REPOSITORY]:[TAG]
```

For example:
```
ghcr.io/slims/slims9_bulian:v9.6.1
```

You can pull the image with:

```bash
docker pull ghcr.io/[OWNER]/[REPOSITORY]:[TAG]
```

### Required Permissions

The workflow uses the `GITHUB_TOKEN` secret which is automatically provided by GitHub Actions. No additional secrets need to be configured.

For the workflow to be able to push to the GitHub Container Registry, the repository needs to have the appropriate permissions:

1. Go to your repository settings
2. Navigate to "Actions" > "General"
3. Under "Workflow permissions", ensure "Read and write permissions" is selected