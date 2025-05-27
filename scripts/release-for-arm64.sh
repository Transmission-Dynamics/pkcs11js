#!/bin/bash
cd "$(dirname "$0")"

OUT_DIR="$(pwd)/../release/pkcs11js/arm64"
mkdir -p ${OUT_DIR}/build/Release/

# Build the container
docker build -t pkcs11-builder -f arm64.Dockerfile ..

# Start container from built image (but don't run anything)
docker create --name pkcs11-temp pkcs11-builder

# Copy the .node file from the container to host
docker cp pkcs11-temp:/app/build/Release/pkcs11.node ${OUT_DIR}/build/Release/pkcs11.node

# Clean up the temporary container and remove the image
docker rm pkcs11-temp
docker rmi pkcs11-builder

cp ../index.js ${OUT_DIR}/index.js
cp ../index.d.ts ${OUT_DIR}/index.d.ts
cp ../package.json ${OUT_DIR}/package.json
