#!/bin/bash

set -euo pipefail

../Godot_v4.5-stable_linux.x86_64 \
    --headless \
    --export-release Web web/index.html
