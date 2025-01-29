import sys
from importlib import util
import json
import shutil

modules: list[str] = json.load(sys.stdin)
available = [module for module in modules if util.find_spec(module)]

if shutil.which("magick"):
    available.append("wal")

if shutil.which("schemer2"):
    available.append("schemer2")

print(json.dumps(available))
