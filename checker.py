import sys
from importlib import util
import json

modules: list[str] = json.load(sys.stdin)
available = [module for module in modules if util.find_spec(module)]
print(json.dumps(available))