import ast
import os

from pathlib import Path

def get_function_name(path):
    with open(path) as file:
        node = ast.parse(file.read())
        return '%s.%s' % (Path(path).stem,  node.body[-1].name)