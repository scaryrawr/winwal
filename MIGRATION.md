# WinWal Migration Guide

## Overview

WinWal has been restructured to improve maintainability and better separate platform-specific code from shared functionality. This document provides guidance on migrating to the new structure.

## What Changed?

The main changes include:

1. **New Directory Structure**
   - `src/Common/` - Contains shared functionality used by all platforms
   - `src/Core/` - PowerShell Core specific implementation
   - `src/Windows/` - Windows PowerShell specific implementation

2. **Module-Based Architecture**
   - Proper PowerShell modules (.psm1) with Import-Module/Export-ModuleMember
   - Clearer dependency management
   - Improved error handling and logging

3. **Centralized Python Environment Management**
   - All Python environment setup now goes through the Environment module
   - Consistent activation/deactivation of virtual environments

4. **Better Configuration & Theme Management**
   - More robust handling of theme detection across platforms
   - Improved Windows Terminal integration

## How To Migrate

### For Users

If you're a user of WinWal, the transition should be seamless:

1. Update your clone of the repository:
   ```powershell
   cd path/to/winwal
   git pull
   ```

2. Run the new setup script:
   ```powershell
   ./setup-module.ps1
   ```

3. Your existing `Import-Module path/to/winwal.psm1` commands in your PowerShell profile will continue to work.

### For Developers

If you've made custom modifications to WinWal:

1. The old file structure still exists and works via compatibility wrappers
2. New development should target the `src/` directory structure
3. Platform-specific code should go in the appropriate subdirectory
4. Common functionality should go in the `src/Common` directory
5. Use proper module imports rather than dot sourcing when possible

## Legacy Support

Backward compatibility is maintained through wrapper scripts that detect and use the new structure when available, but fall back to the original implementation when necessary. This ensures existing installations continue to work without interruption.

## Troubleshooting

If you encounter issues after migrating to the new structure:

1. Try running `./setup-module.ps1 -Force` to recreate the virtual environment
2. Check that you have the necessary permissions to modify files in the module directory
3. Ensure your PowerShell version is compatible (PowerShell Core 6.0+ or Windows PowerShell 5.1+)
4. If issues persist, please open an issue on GitHub
