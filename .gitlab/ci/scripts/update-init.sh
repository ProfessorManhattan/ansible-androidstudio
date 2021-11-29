#!/usr/bin/env bash

# @file .gitlab/ci/scripts/update-init.sh
# @brief Script that executes before the start task if the UPDATE_INIT_SCRIPT is set to the URL
# of this script

set -eo pipefail

# @description Configure git if environment is GitLab CI
if [ -n "$GITLAB_CI" ]; then
  git remote set-url origin "https://root:$GROUP_ACCESS_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git"
  git config user.email "$GITLAB_CI_EMAIL"
  git config user.name "$GITLAB_CI_NAME"
  git checkout "$CI_COMMIT_REF_NAME"
  git pull origin "$CI_COMMIT_REF_NAME"
elif git reset --hard HEAD &> /dev/null; then
  git clean -fxd
  git checkout master
  git pull origin master
fi

# @description Clone shared files repository
rm -rf common-shared
git clone https://gitlab.com/megabyte-labs/common/shared.git common-shared

# @description Refresh taskfiles and GitLab CI files
mkdir -p .config
rm -rf .config/taskfiles
cp -rT common-shared/common/.config/taskfiles .config/taskfiles
mkdir -p .gitlab
rm -rf .gitlab/ci
cp -rT common-shared/common/.gitlab/ci .gitlab/ci

# @description Ensure proper NPM dependencies are installed
npm install --save-dev @mblabs/eslint-config@latest
npm install --save-optional chalk inquirer signale string-break

# @description Re-generate the Taskfile.yml if it has invalid includes
if ! task donothing &> /dev/null; then
  curl -s https://gitlab.com/megabyte-labs/common/shared/-/raw/master/Taskfile.yml > Taskfile-shared.yml
  TMP="$(mktemp)"
  yq eval-all 'select(fileIndex==0).includes = select(fileIndex==1).includes | select(fileIndex==0)' Taskfile.yml Taskfile-shared.yml > "$TMP"
  mv "$TMP" Taskfile.yml
  rm Taskfile-shared.yml
  npm install
  task fix:eslint -- Taskfile.yml
fi

# @description Clean up
rm -rf common-shared

# @description Ensure files from old file structure are removed
rm -f .ansible-lint
rm -f .eslintrc.cjs
rm -f .flake8
rm -f .gitmodules
rm -f .prettierignore
rm -f .start.sh
rm -f .update.sh
rm -f .yamllint
rm -f requirements.txt
rm -rf .common
rm -rf .config/esbuild
rm -rf .husky
rm -rf tests
if test -d .config/docs; then
  cd .config/docs
  rm -rf .git .config .github .gitlab .vscode .editorconfig .gitignore .gitlab-ci.yml
  rm -rf LICENSE Taskfile.yml package-lock.json package.json poetry.lock pyproject.toml
  cd ../..
fi

# @description Ensure documentation is in appropriate location
mkdir -p docs
if test -f "CODE_OF_CONDUCT.md"; then
  mv CODE_OF_CONDUCT.md docs
fi
if test -f "CONTRIBUTING.md"; then
  mv CONTRIBUTING.md docs
fi
if test -f "ARCHITECTURE.md"; then
  mv ARCHITECTURE.md docs
fi

# @description Commit and push the changes
if [ -n "$GITLAB_CI" ]; then
  task ci:commit
fi

# @description Perform post commit tasks that will always cause changes
TMP="$(mktemp)"
jq 'del(."standard-version")' package.json > "$TMP"
mv "$TMP" package.json
TMP="$(mktemp)"
jq 'del(."lint-staged")' package.json > "$TMP"
mv "$TMP" package.json
