## Linting

We utilize several different linters to ensure that all our Dockerfile projects use similar design patterns. Linting sometimes even helps spot errors as well. The most important linter for Dockerfile projects is called [Haskell Dockerfile Linter]({{ website.hadolint_github_page }}) (or hadolint). You can install it by utilizing our one-line installation method found in our [hadolint Ansible role]({{ repository.project.hadolint }}). In order for a merge request to be accepted, it has to successfully pass hadolint tests. For more information about hadolint, check out the [Haskell Dockerfile Linter GitHub page]({{ website.hadolint_github_page }}).

We also incorporate other linters that are run automatically whenever you commit code (assuming you have run `npm i` in the root of the project). These linters include:

- [Prettier]({{ repository.project.prettier }})
- [Shellcheck]({{ repository.project.shellcheck }})

Some of the linters are also baked into the CI pipeline. The pipeline will trigger whenever you post a commit to a branch. All of these pipeline tasks must pass in order for merge requests to be accepted. You can check the status of recently triggered pipelines for this project by going to the [CI/CD pipeline page]({{ repository.group.dockerfile }}/{{ subgroup }}/{{ slug }}/-/pipelines).
