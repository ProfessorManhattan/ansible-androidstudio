## Philosophy

When you are working on one of our Dockerfile projects, try asking yourself, "How can this be improved?" By asking yourself that question, you might decide to take the project a step further by opening a merge request that:

- Reduces the size of the Docker container by converting it from a Ubuntu image to an Alpine image
- Improves the security and reduces the size of the Docker container by including a [DockerSlim]({{ website.dockerslim_github_page }}) configuration
- Lints the Dockerfile to conform with standards set in place by [Haskell Dockerfile Linter]({{ website.hadolint_github_page }})

All of these improvements would be greatly appreciated by us and our community. After all, we want all of our Dockerfiles to be the best at what they do.

### Choosing a Base Image

- Whenever possible, use Alpine as the base image. It has a very small footprint so the container image downloads faster.
- Whenever possible, choose an image with a `slim` tag. This is beneficial when, say, Alpine is incompatible with the requirements and you must use something besides an Alpine image.
- Avoid using the latest tag (e.g. `node:latest`). Instead use specific versions like `node:15.4.2`. This makes debugging production issues easier.
- When choosing a base image version, always choose the most recent update. There are often known vulnerabilities with older versions.
- If all else fails, feel free to use other base images as long as they come from a trusted provider (i.e. using `ubuntu:latest` is fine but using `bobmighthackme:latest` is not).
