#!/bin/bash
cd "$(dirname "$0")"

function build() {
  local arch=$1
  local dockerfile=$2

  docker build -t pkcs11-builder -f ${dockerfile} ..
  
  # Start container from built image (but don't run anything)
  docker create --name pkcs11-temp pkcs11-builder
  
  # Copy the .node file from the container to host
  docker cp pkcs11-temp:/app/build/Release/pkcs11.node ${OUT_DIR}/prebuilds/linux-${arch}/pkcs11.node
  
  # Clean up the temporary container and remove the image
  docker rm pkcs11-temp
  docker rmi pkcs11-builder
}

OUT_DIR="$(pwd)/.."

# Clean up previous builds
rm -fr ${OUT_DIR}/prebuilds
mkdir -p ${OUT_DIR}/prebuilds/linux-arm/
mkdir -p ${OUT_DIR}/prebuilds/linux-arm64/

# Build for arm
build "arm" "arm.Dockerfile"

# Build for arm64
build "arm64" "arm64.Dockerfile"
