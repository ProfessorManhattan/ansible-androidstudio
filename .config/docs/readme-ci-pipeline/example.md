## Example Usage

There are several different ways you can use the Docker container provided by this project. For starters, you can test the feature out locally by running:

```shell
docker run -v ${PWD}:/work -w /work megabytelabs/{{ slug }}:{{ preferred_tag }} {{ docker_command }}
```

This allows you to run {{ pretty_name }} without installing it locally. This could be good for security since the application is within a container and also keeps your file system clean.

You can also add a bash alias to your `~/.bashrc` file so that you can run the {{ pretty_name }} command at any time. To do this, add the following snippet to your `~/.bashrc` file (or `~/.bash_profile` if you are on macOS):

```shell
{{ docker_command_alias }}() {
    docker run -v ${PWD}:/work -w /work megabytelabs/{{ slug }}:{{ preferred_tag }} "$@"
}
```

_Note: Some CLI tools run without any arguments passed in. For example, the CLI tool `ansible-lint` runs by simply entering `ansible-lint` in the terminal. Our Docker images default command is to show the version so to get around this quirk you would run `ansible-lint .`._

### Integrating with GitLab CI

The main purpose of this project is to build a Docker container that can be used in CI pipelines. For example, if you want to incorporate this CI pipeline tool into GitLab CI project then your first step would be to create a `.gitlab-ci.yml` file in the root of your repository that is hosted by GitLab. Your `.gitlab-ci.yml` file should look something like this:

```yaml
---
stages:
  - lint

include:
  - remote: https://gitlab.com/megabyte-space/gitlab-ci-templates/-/raw/master/{{ slug }}.gitlab-ci.yml
```

That is it! {{ pretty_name }} will now run anytime you commit code (that matches the parameters laid out in the `remote:` file above). Ideally, for production, you should copy the source code from the `remote:` link above to another location and update the `remote:` link to the file's new location. That way, you do not have to worry about any changes that are made to the `remote:` file by our team.
