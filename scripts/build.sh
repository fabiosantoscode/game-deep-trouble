#!/bin/bash

set -euo pipefail

GODOT=""

if [ -f ../Godot_v4.5-stable_linux.x86_64 ]; then
	GODOT=../Godot_v4.5-stable_linux.x86_64
else
	GODOT=../Godot_v4.5-stable_win64.exe
fi

"$GODOT" \
    --headless \
    --export-release 'Deep Trouble' web/index.html
