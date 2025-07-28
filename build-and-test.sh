#!/bin/bash

# Adobe India Hackathon 2025 - Challenge 1A Build and Test Script

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}Adobe India Hackathon 2025 - Challenge 1A Script${NC}"
echo -e "${CYAN}===============================================${NC}"

# Function to build Challenge 1A
build_challenge_1a() {
    echo ""
    echo -e "${BLUE}Building Challenge 1A - PDF Outline Extraction${NC}"
    echo -e "${BLUE}---------------------------------------------${NC}"
    
    echo "Building Docker image..."
    docker build --platform linux/amd64 -t pdf-processor:v1.1 .

    echo -e "${GREEN}Build complete!${NC}"
}

# Function to test Challenge 1A
test_challenge_1a() {
    echo ""
    echo -e "${YELLOW}Testing Challenge 1A${NC}"
    echo -e "${YELLOW}---------------------${NC}"
    
    mkdir -p input output

    echo "Running container..."
    docker run --rm \
        -v $(pwd)/input:/app/input:ro \
        -v $(pwd)/output:/app/output \
        --network none \
        pdf-processor:v1.1

    echo -e "${GREEN}Test complete!${NC}"
    echo "Check the output in ./output/"
}

# Function to validate schema
validate_schema() {
    echo ""
    echo -e "${CYAN}Validating Output Schema${NC}"
    echo -e "${CYAN}--------------------------${NC}"
    
    if [ -f "validate_schema.py" ]; then
        python validate_schema.py
    else
        echo -e "${YELLOW}Validation script not found.${NC}"
    fi
}

# Function to clean Docker images
clean() {
    echo ""
    echo -e "${RED}Cleaning Docker image...${NC}"
    docker rmi pdf-processor:v1.1 2>/dev/null || echo "Image not found."
    echo -e "${GREEN}Cleanup complete.${NC}"
}

# Usage help
usage() {
    echo ""
    echo "Usage: $0 [build | test | validate | full | clean | help]"
}

# Main
case "$1" in
    build)
        build_challenge_1a
        ;;
    test)
        build_challenge_1a
        test_challenge_1a
        ;;
    validate)
        validate_schema
        ;;
    full)
        build_challenge_1a
        test_challenge_1a
        validate_schema
        ;;
    clean)
        clean
        ;;
    help|*)
        usage
        ;;
esac

echo ""
echo -e "${CYAN}Challenge 1A Ready!${NC}"
