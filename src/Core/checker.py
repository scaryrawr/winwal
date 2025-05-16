# checker.py - Checks for available Python backends
import sys
from importlib import util
import json
import shutil

# Read the list of modules to check from stdin
try:
    modules = json.load(sys.stdin)
    if not isinstance(modules, list):
        modules = []
except Exception:
    modules = []

# Check which Python modules are available
available = [module for module in modules if util.find_spec(module)]

# Check for ImageMagick (required for 'wal' backend)
if shutil.which("magick"):
    available.append("wal")

# Check for schemer2
if shutil.which("schemer2"):
    available.append("schemer2")

# Output the list of available backends
print(json.dumps(available))
