#!/bin/bash
set -e

echo "🚀 Building Lambda Layer with Pillow using Docker..."

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"
TERRAFORM_DIR="${PROJECT_DIR}/terraform"

mkdir -p "$TERRAFORM_DIR"

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "📖 Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info &> /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "📦 Building layer in Linux container (Python 3.12)..."

CONTAINER_NAME="pillow-layer-build-$$"

# Create (but don't start) a container we can build in and copy from
docker create \
  --platform linux/amd64 \
  --name "$CONTAINER_NAME" \
  python:3.12-slim \
  bash -c "
    pip install --quiet --root-user-action=ignore Pillow==10.4.0 -t /tmp/python/lib/python3.12/site-packages/ && \
    cd /tmp && \
    apt-get update -qq && apt-get install -y -qq zip > /dev/null 2>&1 && \
    zip -q -r pillow_layer.zip python/
  " > /dev/null

# Start it and wait for the build to finish
docker start -a "$CONTAINER_NAME"

echo "📦 Copying layer zip out of the container..."
docker cp "$CONTAINER_NAME":/tmp/pillow_layer.zip "$TERRAFORM_DIR/pillow_layer.zip"

# Clean up the container
docker rm "$CONTAINER_NAME" > /dev/null

echo "📍 Location: $TERRAFORM_DIR/pillow_layer.zip"
echo "✅ Layer is now compatible with AWS Lambda on all platforms!"