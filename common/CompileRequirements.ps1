# Script to compile requirements.in to requirements.txt using uv
Write-Host "Compiling requirements files using uv..."

# First, ensure uv is installed
. "$PSScriptRoot/InstallUV.ps1"

# Compile main requirements file
Write-Host "Compiling main requirements file..."
& uv pip compile "$PSScriptRoot/../requirements.in" --output-file "$PSScriptRoot/../requirements.txt" --universal

# Compile ARM64 requirements file
Write-Host "Compiling ARM64 requirements file..."
& uv pip compile "$PSScriptRoot/../requirements-win32-arm64.in" --output-file "$PSScriptRoot/../requirements-win32-arm64.txt" --universal

Write-Host "Requirements compilation complete."
