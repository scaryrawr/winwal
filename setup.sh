#!/bin/bash

echo "Setting up winwal with uv..."

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Create and activate virtual environment
envDir="./venv"

# Create virtual environment
uv venv $envDir

# Activate the virtual environment
source $envDir/bin/activate

# Install dependencies
echo "Installing dependencies..."
uv pip install -e "."

echo "Setup complete! You can now use winwal."
