## Getting Started

To get started when developing one of [our Dockerfile projects]({{ repository.group.dockerfile }}) (after you have installed [Docker]({{ repository.project.docker }})), the first command you need to run in the root of the project is:

```shell
bash .start.sh
```

This command will:

- Install missing dependencies without sudo (i.e. the binary dependencies will be stored in `~/.local/bin` and your PATH will be updated to reference the `~/.local/bin` directory)
- Ensure Node.js dependencies are installed if the `node_modules/` folder is missing
- Copy (and possibly overwrite) the shared common files from the [Dockerfile common files repository]({{ repository.project.common_docker }}) and the [shared common files repository]({{ repository.project.common_shared }})
- Update the `package.json` file
- Re-generate the documentation
- Register a pre-commit hook that only allows commits to register if tests are passed

### Descriptions of Build Scripts

After you run `npm i` (or `bash .start.sh`), you can view the various build commands by running `npm run info`. This will display a chart in your terminal with descriptions of the build scripts. It might look something like this:

```shell
❯ npm run info

> ansible-lint@0.0.23 info
> npm-scripts-info

build:
  Build the regular Docker image and then build the slim image
build:latest:
  Build the regular Docker image
build:slim:
  Build a compact Docker image with DockerSlim
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

You can then build the Docker image, for instance, by running `npm run build` or list the sizes of Docker images on your system by running `npm run sizes`. You can check out exactly what each command does by looking at the `package.json` file in the root of the project.

### Creating DockerSlim Builds

Whenever possible, a DockerSlim build should be provided and tagged as `:slim`. DockerSlim provides many configuration options so please check out the [DockerSlim documentation]({{ website.dockerslim_github_page }}) to get a thorough understanding of it and what it is capable of. When you have formulated _and fully tested_ the proper DockerSlim configuration, you can add it to the `.blueprint.json` file.

#### How to Determine Which Paths to Include

In most cases, the DockerSlim configuration in `.blueprint.json` (which gets injected into `package.json`) will require the use of `--include-path`. If you were creating a slim build that included `jq`, for instance, then you would need to instruct DockerSlim to hold onto the `jq` binary. You can determine where the binary is stored on the target machine by running:

```bash
npm run shell
which jq
```

You would then need to include the path that the command above displays in the `dockerslim_command` key of `.blueprint.json`. The `.blueprint.json` might look something like this:

```json
{
  ...
  "dockerslim_command": "--http-probe=false --exec 'npm install' --include-path '/usr/bin/jq'"
}
```

#### Determining Binary Dependencies

If you tried to use the `"dockerslim_command"` above, you might notice that it is incomplete. That is because `jq` relies on some libraries that are not bundled into the executable. You can determine the libraries you need to include by using the `ldd` command like this:

```bash
npm run shell
ldd $(which jq)
```

The command above would output something like this:

```shell
	/lib/ld-musl-x86_64.so.1 (0x7fa35376c000)
	libonig.so.5 => /usr/lib/libonig.so.5 (0x7fa35369e000)
	libc.musl-x86_64.so.1 => /lib/ld-musl-x86_64.so.1 (0x7fa35376c000)
```

Using the information above, you can see two unique libraries being used. You should then check out the slim build to see which of the two libraries is missing. This can be done by running:

```bash
echo "***Base image libraries for jq***"
npm run shell
cd /usr/lib
ls | grep libonig.so.5
cd /lib
ls | grep ld-musl-x86_64.so.1
exit
echo "***Slim image libraries for jq***"
npm run shell:slim
cd /usr/lib
ls | grep libonig.so.5
cd /lib
ls | grep ld-musl-x86_64.so.1
exit
```

You should then compare the output from the base image with the slim image. After you compare the two, in this case, you will see that the slim build is missing `/usr/lib/libonig.so.5` and `/usr/lib/libonig.so.5.1.0`. So, finally, you can complete the necessary configuration in `.blueprint.json` by including the paths to the missing libraries:

```json
{
  ...
  "dockerslim_command": "--http-probe=false --exec 'npm install' --include-path '/usr/bin/jq' --include-path '/usr/lib/libonig.so.5' --include-path '/usr/lib/libonig.so.5.1.0'"
}
```

### Using a `paths.txt` File

In the above example, we use `--include-path` to specify each file we want to include in the optimized Docker image. If you are ever including more than a couple includes, you should instead create a line return seperated list of paths to preserve in a file named `paths.txt`. You can then include the paths in the `"dockerslim_command"` by using utilizing `--preserve-path-file`. The `"dockerslim_command"` above would then look like this if you create the `paths.txt` file:

```json
{
  ...
  "dockerslim_command": "--http-probe=false --exec 'npm install' --preserve-path-file 'paths.txt'"
}
```

### Updating the `.blueprint.json` File

The `.blueprint.json` file stores some of the information required to automatically generate, scaffold, and update this repository when `bash .start.sh` is run. When creating a new Dockerfile project, the `.blueprint.json` file must be filled out. The following chart details the possible data that you can populate `.blueprint.json` with:

{{ blueprint_variables }}

When populating the `.blueprint.json` file, it is a good idea to check out [repositories in the same group]({{ repository.group.dockerfile }}/{{ subgroup }}) to see what variables are being utilized.

## Creating a New Dockerfile Project

If you are creating a new Dockerfile project, you should first populate the `.blueprint.json` file as described above. After you have a `.blueprint.json` in the root of the project, you should also copy the `.start.sh` file from another one of our Dockerfile projects. With the files in place, you can then run `bash .start.sh`. This will copy over all the other files and set up the project. You should then:

1. Rename the `"name"` field to the desired image name (e.g. `megabytelabs/**name**:slim`).
2. Code your Dockerfile
3. Create a test case for your Dockerfile (more details are in the [Creating Test Cases](#creating-test-cases) section)
4. Test your Dockerfile by running `npm run test`
5. Build your Dockerfile after you finish coding it using `npm run build`
6. After everything is completely done, test the complete flow by running `npm run publish`
