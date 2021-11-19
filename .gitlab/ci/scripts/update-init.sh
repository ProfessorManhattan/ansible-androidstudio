#!/usr/bin/env bash

# @file .gitlab/ci/scripts/update-init.sh
# @brief Script that executes before any CI update step

set -eo pipefail

echo "Update script running.."
npm install --save-dev @mblabs/eslint-config@latest
