#!/usr/bin/env python3

import re
import os
import json
from sys import argv

common = argv[1] == 'true'

def read_file(file_path):
    with open(file_path) as f:
        return f.readline().strip('\n')[1:-1].split(',')

def process_items(items):
    return {item.strip('"/').removeprefix('src/') for item in items}

packages = process_items(read_file('package_directories.txt'))
plugins = process_items(read_file('plugins.txt'))

list_plugins = set()
for plugin in plugins:
    list_plugins.add(plugin)
    match = re.search(r'(.*)/(?:plugin\.pm|(?:lib|mode|custom)/.+)', plugin)
    if match:
        list_plugins.add(match.group(1))

list_packages = set()
for filepath in os.popen('find packaging -type f -name pkg.json').read().splitlines():
    with open(filepath) as packaging_file:
        packaging = json.load(packaging_file)
    packaging_path = re.search(r'.*/(centreon-plugin-.*)/pkg.json', filepath).group(1)
    packaging_path = packaging_path if packaging_path == packaging["pkg_name"] else packaging["pkg_name"]
    directory_path = re.search(r'^(.+)/pkg.json', filepath).group(1)

    if common or directory_path in packages:
        list_packages.add(packaging_path)
    else:
        for pkg_file in packaging["files"]:
            if pkg_file.strip('/').removeprefix('src/') in list_plugins:
                list_packages.add(packaging_path)

print(*list_packages)