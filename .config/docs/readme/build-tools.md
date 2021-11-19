### Build Tools

You might notice that we have a lot of extra files considering that this repository basically boils down to a single Dockerfile. These extra files are meant to make team development easier, predictable, and enjoyable. If you have a recent version of [Node.js]({{ repository.project.node }}) installed, you can get started using our build tools by running `npm i` (or by running `bash .start.sh` if you do not currently have Node.js installed) in the root of this repository. After that, you can run `npm run info` to see a list of the available development features. The command will output a chart that may look something like this:

```shell
❯ npm run info

> @megabytelabs/docker-ansible-molecule-ubuntu-21.04@0.0.1 info
> npm-scripts-info

build:
  Build the regular Docker image and then build the slim image (if the project supports it)
build:latest:
  Build the regular Docker image
commit:
  The preferred way of running git commit (instead of git commit, we prefer you run 'npm run commit' in the root of this repository)
fix:
  Automatically fix formatting errors
info:
  Logs descriptions of all the npm tasks
prepare-release:
  Updates the CHANGELOG with commits made using 'npm run commit' and updates the project to be ready for release
publish:
  Creates new release(s) and uploads the release(s) to DockerHub
scan:
  Scans images for vulnerabilities
shell:
  Run the Docker container and open a shell
sizes:
  List the sizes of the Docker images on the system
test:
  Validates the Dockerfile, tests the Docker image, and performs project linting
update:
  Runs .start.sh to automatically update meta files and documentation
version:
  Used by 'npm run prepare-release' to update the CHANGELOG and app version
start:
  Kickstart the application
```

For more details, check out the [CONTRIBUTING.md]({{ repository.group.dockerfile }}/{{ subgroup }}/{{ slug }}/-/blob/master/CONTRIBUTING.md) file.
