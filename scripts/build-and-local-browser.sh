#!/bin/bash

set -euo pipefail

./scripts/build.sh

ecstatic ./web --port 9000

