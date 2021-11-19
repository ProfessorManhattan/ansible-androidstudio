## Example Usage

Without having to clone this repository, you can pull the latest Dockerfile to have the image cached locally by running:

```shell
docker pull megabytelabs/{{ slug }}:latest
```

### Experimenting / Shelling Into Container

Although this image is intended to be used with Ansible Molecule (which is described below), you can start the container and shell into it for debugging or for curiousity's sake by running the following commands:

```shell
docker run megabytelabs/{{ slug }}:latest
docker exec -it megabytelabs/{{ slug }}:latest /bin/bash
```

Note that after you exit from the shell session, the container will still be running. After you are done experimenting with the container, you can destroy it by running:

```shell
docker ps -a # Copy the ID of the image you wish to delete
docker rm ID_FROM_ABOVE_COMMAND_HERE
```

Alternatively, you can shell into the container and have Docker automatically remove the container when you exit by running:

```shell
docker run -it --rm megabytelabs/{{ slug }}:latest /bin/sh
```
