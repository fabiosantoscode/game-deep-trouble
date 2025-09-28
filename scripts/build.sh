#!/bin/bash

set -euo pipefail


../Godot_v4.4.1-stable_linux.x86_64 \
    --headless \
    --export-debug Web web/index.html

