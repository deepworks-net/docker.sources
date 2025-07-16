# docker.sources

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/deepworks-net/docker.sources/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/docker-ready-brightgreen.svg)](https://hub.docker.com/r/deepworks/docker.sources)

A Docker image that provides a clean, reproducible environment for downloading and managing Apache httpd and OpenSSL source code. This image serves as a foundation for building custom Apache installations with specific configurations.

## Overview

The `docker.sources` image automates the process of:
- Downloading Apache httpd, APR, APR-util, and OpenSSL source code
- Verifying checksums for security
- Organizing sources in a consistent structure
- Providing both standard and bootable image variants

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Clone the repository with submodules
git clone --recursive https://github.com/deepworks-net/docker.sources.git
cd docker.sources

# Copy the default environment file
cp .env.default .env

# Build and run the image
docker-compose up --build
```

### Using Docker CLI

```bash
# Build the image
docker build \
  --build-arg VERSION=sources \
  --build-arg IMAGE_NAME=deepworks/docker.sources \
  --build-arg IMAGE_VERSION=1.0.0 \
  --build-arg BASE_IMAGE_NAME=alpine \
  --build-arg BASE_IMAGE_VERSION=3.12.7 \
  --build-arg MAINTAINER=deepworks \
  --build-arg THEEMAIL=support@deepworks.net \
  --build-arg HOMEDIR=/.deepworks/ \
  -t deepworks/docker.sources:1.0.0 .

# Run the container
docker run -it deepworks/docker.sources:1.0.0 /bin/sh
```

## Environment Variables

Configure the build process using these environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `IMAGE_NAME` | Name of the Docker image | `deepworks/docker.sources` |
| `IMAGE_VERSION` | Version tag for the image | `1.0.0` |
| `BASE_IMAGE_NAME` | Base image to build from | `alpine` |
| `BASE_IMAGE_VERSION` | Version of the base image | `3.12.7` |
| `MAINTAINER` | Image maintainer name | `deepworks` |
| `THEEMAIL` | Maintainer email | `support@deepworks.net` |
| `HOMEDIR` | Home directory in container | `/.deepworks/` |

## Image Variants

### Standard Image
The default image contains source files in a minimal scratch-based layer:
- Minimal size
- Source files only
- No runtime dependencies

### Bootable Image
An alternative variant that includes a full Alpine Linux environment:
- Includes shell and basic utilities
- Can be used interactively
- Useful for debugging and development

To build the bootable variant, uncomment the `latest-bootable` service in `docker-compose.yml`.

## Directory Structure

Once built, the image contains:

```
/sources/
├── httpd-src/          # Apache httpd source code
├── openssl-src/        # OpenSSL source code
└── /.deepworks/        # Branding and metadata
```

## Source Components

The image includes the following components:

| Component | Version | Description |
|-----------|---------|-------------|
| Apache httpd | 2.4.64 | Web server |
| OpenSSL | 3.5.1 | Cryptography library |
| APR | 1.7.6 | Apache Portable Runtime |
| APR-util | 1.6.3 | APR utilities |
| mod_fcgid | 2.3.9 | FastCGI module |

All sources are verified using SHA256 checksums before inclusion.

## Submodules

This repository includes two Git submodules:

1. **Apache Utilities** (`build/`) - Apache configuration and build scripts
   - Repository: [https://github.com/deepworks-net/utilities.apache.git](https://github.com/deepworks-net/utilities.apache.git)
   - Provides customizable Apache httpd build configurations
   - Supports Alpine, CentOS 7/8, and Rocky Linux
   - Includes SSL/TLS configuration management

2. **Docker Utilities** (`scripts/utils/`) - Docker build and deployment utilities
   - Repository: [https://github.com/deepworks-net/utilities.docker.git](https://github.com/deepworks-net/utilities.docker.git)
   - Version: v0.2.2-beta
   - Provides Docker image building, tagging, and publishing functions
   - Includes semantic versioning support

### Initializing Submodules

If you cloned without `--recursive`, initialize the submodules:

```bash
git submodule update --init --recursive
```

## Building Custom Apache Installations

This image uses the Apache configuration scripts from the `build/` submodule. These scripts provide:

- Customizable installation layouts
- Flexible compilation options
- Support for multiple Linux distributions
- SSL/TLS configuration management

For detailed information about building Apache from these sources, see the [Apache Configuration Scripts documentation](https://github.com/deepworks-net/utilities.apache).

## Advanced Usage

### Extracting Sources

To extract sources from the image to your host system:

```bash
# Create a temporary container
docker create --name temp-sources deepworks/docker.sources:1.0.0

# Copy sources to host
docker cp temp-sources:/sources ./extracted-sources

# Clean up
docker rm temp-sources
```

### Multi-stage Builds

Use this image as a base in multi-stage builds:

```dockerfile
FROM deepworks/docker.sources:1.0.0 AS sources

FROM alpine:3.12.7 AS builder
COPY --from=sources /sources /tmp/sources
# Continue with your build process...
```

## Security

- All source downloads are verified using SHA256 checksums
- The base Alpine image is regularly updated
- No unnecessary packages or dependencies included
- Follows Docker best practices for minimal attack surface

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or contributions:
- GitHub Issues: [https://github.com/deepworks-net/docker.sources/issues](https://github.com/deepworks-net/docker.sources/issues)
- Email: support@deepworks.net

## Acknowledgments

This project leverages two external utilities as Git submodules:
- [Apache Utilities](https://github.com/deepworks-net/utilities.apache) for Apache build configurations
- [Docker Utilities](https://github.com/deepworks-net/utilities.docker) (v0.2.2-beta) for Docker build and deployment management
