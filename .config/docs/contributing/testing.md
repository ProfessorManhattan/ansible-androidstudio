## Testing

Testing is an **extremely important** part of contributing to this project. Before opening a merge request, **you must test all common use cases of the Docker image**. This should be relatively straight-forward. You should be able to run all of the commands described by `npm run info` successfully.

### Creating Test Cases

`npm run test` will test several elements of the project. It will lint the Dockerfile, lint shell scripts, and run the file in `./slim_test/test.sh`. The test case, defined in `test.sh`, is mainly for testing that slim builds work as expected but should also be utilized across all of our Dockerfile projects. In a standard test for a project with a slim build, you should compare the output of a command run against a regular build and a test build. You can accomplish this by using code similar to the following:

**`./slim_test/test.sh`**

```bash
#!/bin/bash

cd ./slim_test/example || exit 1
echo "Testing latest image"
LATEST_OUTPUT=$(docker run -v "${PWD}:/work" -w /work megabytelabs/ansible-lint:latest ansible-lint)
echo "Testing slim image"
SLIM_OUTPUT=$(docker run -v "${PWD}:/work" -w /work megabytelabs/ansible-lint:slim ansible-lint)
if [ "$LATEST_OUTPUT" == "$SLIM_OUTPUT" ]; then
  echo "Slim image appears to be working"
  exit 0
else
  echo "Slim image output differs from latest image output"
  exit 1
fi
```

**Note: The test.sh file is now created from a template. To make sure it gets generated, you should create the `slim_test/` folder in the root of the project and then run `bash .start.sh`. The template version of `test.sh` will recursively loop through all of the folders inside the `slim_test/` folder unlike the example above which only tests the `slim_test/example/` scenario.**

The above script, combined with some dummy data in `slim_test/example/`, will properly validate that the slim build is working the same way the regular build is working. If no `slim_test/` folder exists in the root of the repository, then the test step will be removed from `package.json`. We prefer you create a test that validates that the container is working whenever possible but in some cases it might not be necessary especially when there is no slim version. For a full example of implementing a test, please see the [Ansible Lint repository]({{ repository.project.ansiblelint }}).

### Testing DockerSlim Builds

It is especially important to test DockerSlim builds. DockerSlim works by removing all the components in a container's operating system that it thinks are unnecessary. This can easily break things.

For example, if you are testing a DockerSlim build that packages [ansible-lint]({{ repository.project.ansiblelint }}) into a slim container, you might be tempted to simply test it by running `docker exec -it MySlimAnsibleLint ansible-lint`. This will ensure that the ansible-lint command can be accessed but that is not enough. You should also test it by passing in files as a volume and command line arguments. You can see an [example of this in the Ansible Lint repository]({{ repository.project.ansiblelint }}).

It is **important** to test all common use cases. Some people might be using the `ansible-lint` container in CI where the files are injected into the Docker container and some people might be using an inline command to directly access ansible-lint from the host.

### Testing Web Apps

When testing Docker-based web applications, ensure that after you destroy the container along with its volumes you can bring the Docker container back up to its previous state using volumes and file mounts. This allows users to periodically update the Docker container while having their settings persist. This requirement is also for disaster recovery.
