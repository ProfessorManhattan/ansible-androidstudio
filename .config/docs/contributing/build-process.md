## Build Process

### docker pushrm

One of the build tools we utilize is [docker pushrm](https://github.com/christian-korneck/docker-pushrm). We leverage it to automatically update the README on the Docker Hub page as well as the short description during the `npm run publish` process. The short description is stored in the `.blueprint.json` file under the key `"dockerhub_description"`. It is important to note that Docker Hub limits the length of the short description to 100 characters.
