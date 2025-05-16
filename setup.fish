#!/bin/fish

echo "Setting up winwal with uv..."

# Check if uv is installed
if not command -v uv >/dev/null
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
end

# Create and activate virtual environment
set envDir "./venv"

# Create virtual environment
uv venv $envDir

# Activate the virtual environment
source $envDir/bin/activate.fish

# Install dependencies
echo "Installing dependencies..."
uv pip install -e "."

echo "Setup complete! You can now use winwal."
