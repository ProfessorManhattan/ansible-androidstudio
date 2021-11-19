#!/usr/bin/env bash

# @file .config/scripts/start.sh
# @brief Ensures Task is installed and up-to-date and then runs `task start`
# @description
#   This script will ensure [Task](https://github.com/go-task/task) is up-to-date
#   and then run the `start` task which is generally a good entrypoint for any repository
#   that is using the Megabyte Labs templating/taskfile system. The `start` task will
#   ensure that the latest upstream changes are retrieved, that the project is
#   properly generated with them, and that all the development dependencies are installed.

set -eo pipefail

# @description Detect script paths
BASH_SRC="$(dirname "${BASH_SOURCE[0]}")"
SOURCE_PATH="$(cd "$BASH_SRC"; pwd -P)"
PROJECT_BASE_DIR="$SOURCE_PATH/../.."
INSTALL_TASK_SCRIPT="$SOURCE_PATH/lib/task.sh"

# @description Attempts to pull the latest changes if the folder is a git repository
cd "$PROJECT_BASE_DIR" || exit
if [ -d .git ] && type git &> /dev/null; then
  git pull origin master --ff-only
  git submodule update --init --recursive
fi

# @description Ensures Task is installed and properly configured and then runs the `start` task
bash "$INSTALL_TASK_SCRIPT"
cd "$PROJECT_BASE_DIR" || exit
task start
