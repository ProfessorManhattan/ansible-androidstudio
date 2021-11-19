### Building the Docker Container

You may have a use case that requires some modifications to our Docker image. After you make changes to the Dockerfile, you can upload your custom container to [Docker Hub]({{ website.dockerhub }}) using the following code:

```shell
export DOCKERHUB_USERNAME=Your_DockerHub_Username_Here
export DOCKERHUB_PASSWORD=Your_DockerHub_Password_Here
docker login -u "$DOCKERHUB_USERNAME" -p "$DOCKERHUB_PASSWORD" docker.io
docker build --pull -t "$DOCKERHUB_USERNAME/{{ slug }}:latest" .
docker push "$DOCKERHUB_USERNAME/{{ slug }}:latest"
```

After setting your DockerHub username and password, the commands above will build the Docker image and upload it to [Docker Hub](https://hub.docker.com/) where it will be publicly accessible. You can see this logic being implemented as a [GitLab CI task here]({{ repository.link.dockerhub_ci_task }}). This GitLab CI task works in conjunction with the `.gitlab-ci.yml` file in the root of this repository.
