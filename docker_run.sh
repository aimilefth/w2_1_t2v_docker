#!/bin/bash
# Usage: ./docker_run.sh [GPU_ID] [OUTPUT_DIRECTORY]
# GPU_ID: Specify the GPU index (default: 0)
# OUTPUT_DIRECTORY: Host directory for generated videos (default: ./output)

GPU_ID=${1:-0}
OUTPUT_DIR=${2:-$(pwd)/outputs}
MODELS_DIR=${3:-$(pwd)/models}

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run the container with the chosen GPU and mount the output directory
docker run --gpus "device=${GPU_ID}" -it --rm \
    -v "$OUTPUT_DIR":/app/output \
    -v "$MODELS_DIR":/app/models \
    --pull=always \
    aimilefth/wan2-1-t2v-docker:latest
