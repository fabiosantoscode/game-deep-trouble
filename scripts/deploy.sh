#!/bin/bash

set -euo pipefail

DIST_DIR="web"
BUTLER=""
# To ship to prod, override from the outside
ITCH_CHANNEL="${ITCH_CHANNEL:-fabiosantoscode/test-submarine-game:html}"

if [ -f '/g/My Drive/Software/butler/butler.exe' ]; then
	BUTLER='/g/My Drive/Software/butler/butler.exe'
else
	BUTLER="butler"
fi

# 1. Publish to personal account on itch
"$BUTLER" push "$DIST_DIR/" "$ITCH_CHANNEL"

echo "✅ Deployed to itch!"

