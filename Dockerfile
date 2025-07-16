# Declare Vars - These are required and need to be passed in/set via Environmental Variable!
ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
ARG VERSION

# Image to download sources
FROM ${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION} AS base_sources

# Declare Vars - These are meant to be passed in/set via Environmental Variable!
ARG IMAGE_NAME
ARG IMAGE_VERSION
ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
ARG MAINTAINER
ARG THEEMAIL
ARG THEDIRECTORY
ARG OUT=/sources

# Add wget
RUN apk add wget tar && mkdir "${OUT}"

# Set Working directory
WORKDIR "${OUT}"

# Copy Script
COPY "build/scripts/sources" "${OUT}/sources"

# Run Script to get all sources
RUN cd "sources" && \
    chmod +x ./get-sources.sh && \
    ./get-sources.sh && \
    cd .. && \
    mv "sources/httpd-src" . && \
    mv "sources/openssl-src" . && \
    rm -r "sources"

# Sources Layer
FROM scratch AS base-sources
ARG THEDIRECTORY
# Copy all source files
COPY --from=base_sources /sources /sources
# Copy branding
COPY --from=base_sources "${THEDIRECTORY}" "${THEDIRECTORY}"

# Bootable Layer
FROM base_sources AS base-sources-bootable
# Copy all files
COPY --from=base_sources / /

# 'IF' Layer
FROM base-${VERSION} AS base

# Add all changes to scratch image
FROM scratch AS final

# Declare Vars - These are meant to be passed in/set via Environmental Variable!
ARG IMAGE_NAME
ARG IMAGE_VERSION
ARG BASE_IMAGE_NAME
ARG BASE_IMAGE_VERSION
ARG MAINTAINER
ARG THEEMAIL
ARG THEDIRECTORY
ARG OUT=/sources

# Set the WorkDir
WORKDIR "${OUT}"

# Copy all files
COPY --from=base / /

# Set Metadata
LABEL maintainer="${MAINTAINER}" \
        osimage="${BASE_IMAGE_NAME}:${BASE_IMAGE_VERSION}" \
        baseimage="${IMAGE_NAME}:${IMAGE_VERSION}" \
        image="${IMAGE_NAME}" \
        version="${IMAGE_VERSION}" \
        email="${THEEMAIL}"

# Set locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV MAINTAINER "${MAINTAINER}"

# No Healthcheck for this image
HEALTHCHECK NONE
