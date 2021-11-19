## Updating Meta Files and Documentation

Since we have hundreds of projects to maintain, the majority of the files inside each of our projects are shared across all the other projects of the same type. You can check out our [documentation group](https://gitlab.com/megabyte-labs/documentation) and [common files group](https://gitlab.com/megabyte-labs/common) to get an idea of how we seperate project types. We synchronize these common files across all our repositories with the `.start.sh` file. This file is automatically called when you run `npm i`. If you would like to update the project without running `npm i`, you can also just directly call the script by running `bash .start.sh`. You might want to do this to get the latest upstream changes or if you make an edit to the `.blueprint.json` file (which populates the common files to make them specific to the current project).

### `.blueprint.json` and @appnest/readme

In the root of all of our repositories, we include a file named `.blueprint.json`. This file stores variables that are used in our `.start.sh` script. Most of the variables stored in `.blueprint.json` are used for generating documentation. All of our documentation is generated using variables and document partials that we feed into a project called [@appnest/readme](https://github.com/andreasbm/readme) (which is in charge of generating the final README/CONTRIBUTING guides). When @appnest/readme is run, it includes the variables stored in `.blueprint.json` in the context that it uses to inject variables in the documentation. You can view the documentation partials by checking out the `./.modules/docs` folder which is a submodule that is shared across all our projects of the same type.

For every project that is included in our eco-system, we require certain fields to be filled out in the `.blueprint.json` file. Some of the fields in the file are auto-generated. The fields that need to be filled out as well as descriptions of what they should contain are listed in the chart below:

{{ blueprint_variables }}

### `logo.png`

We include a `logo.png` file in all of our projects. This image is automatically integrated with GitLab so that a thumbnail appears next to the project. It is also shown in the README to give the user a better idea of what the project relates to. All repositories should include the `logo.png` file. When adding a `logo.png` file please _strictly_ adhere to the steps below:

1. Use Google image search to find a logo that best represents the product. Ensure the image is a `.png` file and that it has a transparent background, if possible. Ideally, the image should be the official logo if the repository would be best represented by an official logo. The image should be at least 200x200 pixels.
2. After downloading the image, ensure you have the sharp-cli installed by running `npm install -g sharp-cli`.
3. Resize the image to 200x200 pixels by running `sharp -i file_location.png -o logo.png resize 200 200`.
4. Compress the resized image by dragging and dropping the resized image into the [TinyPNG web application](https://tinypng.com/).
5. Download the compressed image and add it to the root of the repository. Make sure it is named `logo.png`.
