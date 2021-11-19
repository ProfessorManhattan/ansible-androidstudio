## Requirements

- **[Docker](https://gitlab.com/megabyte-labs/ansible-roles/docker)**

### Optional Requirements

- [DockerSlim]({{ repository.project.dockerslim }}) - Used for generating compact, secure images
- [jq]({{ repository.project.jq }}) - Used by `.start.sh` to interact with JSON documents from the bash shell
- [Node.js]({{ repository.project.node }}) (_Version >=10_) - Utilized to add development features like a pre-commit hook and maintenance tasks

If you choose to utilize the development tools provided by this project then at some point you will have to run `bash .start.sh` (or `npm i` which calls `bash .start.sh` after it is done). The `.start.sh` script will attempt to automatically install any requirements (without sudo) that are not already present on your build system to the user's `~/.local/bin` folder. The `.start.sh` script also takes care of other tasks such as generating the documentation. For more details on how the Optional Requirements are used and set up, check out the [CONTRIBUTING.md]({{ repository.group.dockerfile }}/{{ subgroup }}/{{ slug }}/-/blob/master/CONTRIBUTING.md) guide.
