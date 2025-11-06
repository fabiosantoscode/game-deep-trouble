#!/bin/bash

set -euo pipefail

./scripts/build.sh

python -m http.server 8060 --directory ./web

