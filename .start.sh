#!/bin/bash

# @file .start.sh
# @brief Ensures the project is up-to-date with the latest upstream changes
# @description
#   This script performs maintenance on this repository. It ensures the `.common` submodule is
#   cloned and up-to-date. The `.common` submodule contains files that are shared between projects
#   that are similar to this one. It also ensures the repository contains the latest code. This
#   script calls the script in `.common/update.sh` which will make sure the project is
#   bootstrapped. `bash .start.sh` is the first command you should run when working with this project.

set -e
export REPO_TYPE=ansible

if [ -d .git ]; then
  git pull origin master --ff-only
  git submodule update --init --recursive
fi

if [ ! -d .common ]; then
  git submodule add -b master "https://gitlab.com/megabyte-space/common/$REPO_TYPE.git" ".common"
else
  cd .common
  git checkout master && git pull origin master --ff-only
  cd ..
fi

bash .common/update.sh
