#!/bin/bash

# Enable strict mode for better error handling
set -euo pipefail

# Define log file
LOG_FILE="/var/log/docker_cleanup.log"

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &>/dev/null; then
        log "Docker is not installed. Exiting."
        exit 1
    fi
}

# Function to clean up Docker images
clean_images() {
    log "Removing unused Docker images..."
    docker image prune -f | tee -a "$LOG_FILE"
}

# Function to clean up Docker containers
clean_containers() {
    log "Removing stopped Docker containers..."
    docker container prune -f | tee -a "$LOG_FILE"
}

# Function to clean up Docker volumes
clean_volumes() {
    log "Removing unused Docker volumes..."
    docker volume prune -f | tee -a "$LOG_FILE"
}

# Confirmation prompt
read -p "Are you sure you want to clean up Docker resources? (y/N): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "Cleanup canceled by user."
    exit 0
fi

# Check if Docker is installed
check_docker

# Run cleanup tasks
clean_images
clean_containers
clean_volumes

log "Docker cleanup completed successfully!"
exit 0
