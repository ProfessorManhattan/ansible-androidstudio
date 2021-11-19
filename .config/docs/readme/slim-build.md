### Building a Slim Container

Some of our repositories support creating a slim build via [DockerSlim](https://gitlab.com/megabyte-labs/ansible-roles/dockerslim). According to [DockerSlim's GitHub page](https://github.com/docker-slim/docker-slim), slimming down containers reduces the final image size and improves the security of the image by reducing the attack surface. It makes sense to create a slim build for anything that supports it, including Alpine images. On their GitHub page, they report that some images can be reduced in size by up to 448.76X. This means that if your image is naturally **700MB** then it **can be reduced to 1.56MB**! It works by removing everything that is unnecessary in the container image.

As a convenience feature, we include a command defined in `package.json` that should build the slim image. Just run `npm run build:slim` after running `npm i` (or `bash .start.sh` if you do not have `Node.js` installed) in the root of this repository to build a slim build.

To build and publish a slim Dockerfile to Docker Hub, you can use the following as a starting point:

```shell
export DOCKERHUB_USERNAME=Your_DockerHub_Username_Here
export DOCKERHUB_PASSWORD=Your_DockerHub_Password_Here
docker login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_PASSWORD" docker.io
docker build -t "$DOCKERHUB_USERNAME/{{ slug }}:latest" .
docker-slim build --tag $DOCKERHUB_USERNAME/{{ slug }}:slim DOCKER_SLIM_BUILD_COMMAND $DOCKERHUB_USERNAME/{{ slug }}:latest
docker push "$DOCKERHUB_USERNAME/{{ slug }}:slim"
```

It may be possible to modify the DockerSlim command above to fix an issue or reduce the footprint even more than our command. You can modify the slim build command inline in the `package.json` file. However, running `bash .start.sh` will overwrite your changes in the `package.json` file. We detail a better way of modifying the `npm run build:slim` configuration in [CONTRIBUTING.md]({{ repository.group.dockerfile }}/{{ subgroup }}/{{ slug }}/-/blob/master/CONTRIBUTING.md).

If you come up with an improvement, please do [open a pull request]({{ repository.group.dockerfile_ci}}/{{ slug }}/-/issues/new). And again, make sure you replace `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` in the snippet above with your Docker Hub username and password. The commands in the snippet above will build the slim Docker image and upload it to [Docker Hub](https://hub.docker.com/) where it will be publicly accessible. You can see this logic being implemented as a [GitLab CI task here]({{ repository.link.dockerhub_ci_task_slim }}).
