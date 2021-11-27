#!/usr/bin/env bash

# @file .gitlab/ci/scripts/update-init.sh
# @brief Script that executes before any CI update step

set -eo pipefail

echo "Update script running.."
if [ -n "$GITLAB_CI" ]; then
  git remote set-url origin "https://root:$GROUP_ACCESS_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH.git"
  git config user.email "$GITLAB_CI_EMAIL"
  git config user.name "$GITLAB_CI_NAME"
  git checkout "$CI_COMMIT_REF_NAME"
  git pull origin "$CI_COMMIT_REF_NAME"
fi
npm install --save-dev @mblabs/eslint-config@latest

rm -f .config/taskfiles/Taskfile-ci.yml
rm -f .config/taskfiles/Taskfile-docker.yml
rm -f .config/taskfiles/Taskfile-fix.yml
rm -f .config/taskfiles/Taskfile-git.yml
rm -f .config/taskfiles/Taskfile-image.yml
rm -f .config/taskfiles/Taskfile-packer.yml
rm -f .config/taskfiles/Taskfile-python.yml
rm -f .config/taskfiles/Taskfile-security.yml
rm -f .config/taskfiles/Taskfile-symlink.yml
rm -f .config/taskfiles/Taskfile-vscode.yml
TMP="$(mktemp)"
jq 'del(."standard-version")' package.json > "$TMP"
mv "$TMP" package.json
TMP="$(mktemp)"
jq 'del(."lint-staged")' package.json > "$TMP"
mv "$TMP" package.json
mkdir -p docs
mv CODE_OF_CONDUCT.md docs || true
mv CONTRIBUTING.md docs || true
npm install --save-optional chalk inquirer signale
rm -rf .config/esbuild
if test -d .config/docs; then
  cd .config/docs
  rm -rf .git .config .github .gitlab .vscode .editorconfig .gitignore .gitlab-ci.yml
  rm -rf LICENSE Taskfile.yml package-lock.json package.json poetry.lock pyproject.toml
  cd ../..
fi
curl -s https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/.config/taskfiles/upstream/Taskfile-common.yml > .config/taskfiles/upstream/Taskfile-common.yml
curl -s https://gitlab.com/megabyte-labs/common/shared/-/raw/master/common/.config/taskfiles/upstream/Taskfile-project.yml > .config/taskfiles/upstream/Taskfile-project.yml
curl -s https://gitlab.com/megabyte-labs/common/shared/-/raw/master/Taskfile.yml > Taskfile-shared.yml
TMP="$(mktemp)"
yq eval-all 'select(fileIndex==0).includes = select(fileIndex==1).includes | select(fileIndex==0)' Taskfile.yml Taskfile-shared.yml > "$TMP"
mv "$TMP" Taskfile.yml
rm Taskfile-shared.yml
git clone https://gitlab.com/megabyte-labs/common/shared.git common-shared
cp -rT common-shared/common/.config/taskfiles .config/taskfiles
rm -rf common-shared
if [ -n "$GITLAB_CI" ]; then
  task ci:commit
fi
