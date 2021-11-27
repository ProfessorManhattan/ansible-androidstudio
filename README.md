<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-readme-role.md" ⚠️--><div align="center">
  <center>
    <a href="https://github.com/ProfessorManhattan/ansible-androidstudio">
      <img width="148" height="148" alt="Android Studio logo" src="https://gitlab.com/megabyte-labs/ansible-roles/androidstudio/-/raw/master/logo.png" />
    </a>
  </center>
</div>
<div align="center">
  <center><h1 align="center">Ansible Role: Android Studio - An IDE for Android Development<i></i></h1></center>
  <center><h4 style="color: #18c3d1;">An Ansible role brought to you by <a href="https://megabyte.space" target="_blank">Megabyte Labs</a></h4><i></i></center>
</div>

<div align="center">
  <a href="https://megabyte.space" title="Megabyte Labs homepage" target="_blank">
    <img alt="Homepage" src="https://img.shields.io/website?down_color=%23FF4136&down_message=Down&label=Homepage&logo=home-assistant&logoColor=white&up_color=%232ECC40&up_message=Up&url=https%3A%2F%2Fmegabyte.space&style=for-the-badge" />
  </a>
  <a href="https://galaxy.ansible.com/professormanhattan/androidstudio" title="Android Studio role on Ansible Galaxy" target="_blank">
    <img alt="Ansible Galaxy" src="https://img.shields.io/badge/Ansible-Galaxy-000000?logo=ansible&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/ProfessorManhattan/ansible-androidstudio/blob/master/CONTRIBUTING.md" title="Learn about contributing" target="_blank">
    <img alt="Contributing" src="https://img.shields.io/badge/Contributing-Guide-0074D9?logo=github-sponsors&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://www.patreon.com/ProfessorManhattan" title="Support us on Patreon" target="_blank">
    <img alt="Patreon" src="https://img.shields.io/badge/Patreon-Support-052d49?logo=patreon&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/" title="Chat with us on Slack" target="_blank">
    <img alt="Slack" src="https://img.shields.io/badge/Slack-Chat-e01e5a?logo=slack&logoColor=white&style=for-the-badge" />
  </a>
  <a href="https://github.com/ProfessorManhattan/ansible-androidstudio" title="GitHub mirror" target="_blank">
    <img alt="GitHub" src="https://img.shields.io/badge/Mirror-GitHub-333333?logo=github&style=for-the-badge" />
  </a>
  <a href="https://gitlab.com/megabyte-labs/ansible-roles/androidstudio" title="GitLab repository" target="_blank">
    <img alt="GitLab" src="https://img.shields.io/badge/Repo-GitLab-fc6d26?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHJJREFUCNdNxKENwzAQQNEfWU1ZPUF1cxR5lYxQqQMkLEsUdIxCM7PMkMgLGB6wopxkYvAeI0xdHkqXgCLL0Beiqy2CmUIdeYs+WioqVF9C6/RlZvblRNZD8etRuKe843KKkBPw2azX13r+rdvPctEaFi4NVzAN2FhJMQAAAABJRU5ErkJggg==&style=for-the-badge" />
  </a>
</div>
<br/>
<div align="center">
  <a title="Ansible Galaxy role: professormanhattan.androidstudio" href="https://galaxy.ansible.com/professormanhattan/androidstudio" target="_blank">
    <img alt="Ansible Galaxy role: professormanhattan.androidstudio" src="https://img.shields.io/ansible/role/56329?logo=ansible&style=for-the-badge" />
  </a>
  <a title="Version: 1.1.14" href="https://github.com/ProfessorManhattan/ansible-androidstudio" target="_blank">
    <img alt="Version: 1.1.14" src="https://img.shields.io/badge/version-1.1.14-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAACNJREFUCNdjIACY//+BEp9hhM3hAzYQwoBIAqEDYQrCZLwAAGlFKxU1nF9cAAAAAElFTkSuQmCC&cacheSeconds=2592000&style=for-the-badge" />
  </a>
  <a title="Windows 11 build status on GitHub" href="https://github.com/ProfessorManhattan/ansible-androidstudio/actions/workflows/Windows.yml" target="_blank">
    <img alt="Windows 11 build status" src="https://img.shields.io/github/workflow/status/ProfessorManhattan/ansible-androidstudio/Windows/master?color=cyan&label=Windows&logo=windows&style=for-the-badge">
  </a>
  <a title="macOS build status on GitHub" href="https://github.com/ProfessorManhattan/ansible-androidstudio/actions/workflows/macOS.yml" target="_blank">
    <img alt="macOS build status" src="https://img.shields.io/github/workflow/status/ProfessorManhattan/ansible-androidstudio/macOS/master?label=macOS&logo=apple&style=for-the-badge">
  </a>
  <a title="Linux build status on GitLab" href="https://gitlab.com/megabyte-labs/ansible-roles/androidstudio/-/commits/master" target="_blank">
    <img alt="Linux build status" src="https://img.shields.io/badge/dynamic/json?color=ffdc00&label=Linux&query=%24%5B0%5D.status&url=https%3A%2F%2Fgitlab.com%2Fapi%2Fv4%2Fprojects%2Fmegabyte-labs%252Fansible-roles%252Fandroidstudio%2Fpipelines&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAElBMVEUAAAAwPEEuOEIxOzswPj7///91+pI+AAAABXRSTlMANRkNJejDPNcAAAB+SURBVCjPddHBDYAgDIXhGtMRHMG7S3hvTP79VxFIQVq1wOVLm7wU8QIJpSThC2wGwwJoPQFKRdiAAIhGsAykZNSZAOVNMx4BMjwtpySgr6CDJdB/MAdJwAvSiFoE5aABHUb0ch0WHNQq+KPAOgCgrbEnbjAHArjGz3jr3hpumrQpvwi66rkAAAAASUVORK5CYII=&style=for-the-badge">
  </a>
  <a title="Ansible Galaxy quality score (out of 5)" href="https://galaxy.ansible.com/professormanhattan/androidstudio" target="_blank">
    <img alt="Ansible Galaxy quality score" src="https://img.shields.io/ansible/quality/56329?logo=ansible&style=for-the-badge" />
  </a>
  <a title="Ansible Galaxy download count" href="https://galaxy.ansible.com/professormanhattan/androidstudio" target="_blank">
    <img alt="Ansible Galaxy download count" src="https://img.shields.io/ansible/role/d/56329?logo=ansible&label=Downloads&style=for-the-badge">
  </a>
  <a title="Documentation" href="https://megabyte.space/docs/ansible" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg?logo=readthedocs&style=for-the-badge" />
  </a>
  <a title="License: MIT" href="https://github.com/ProfessorManhattan/ansible-androidstudio/blob/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-yellow.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgAQMAAABJtOi3AAAABlBMVEUAAAD///+l2Z/dAAAAAXRSTlMAQObYZgAAAHpJREFUCNdjYOD/wMDAUP+PgYHxhzwDA/MB5gMM7AwMDxj4GBgKGGQYGCyAEEgbMDDwAAWAwmk8958xpIOI5zKH2RmOyhxmZjguAiKmgIgtQOIYmFgCIp4AlaQ9OczGkJYCJEAGgI0CGwo2HmwR2Eqw5SBnNIAdBHYaAJb6KLM15W/CAAAAAElFTkSuQmCC&style=for-the-badge" />
  </a>
  <a title="Support us on Open Collective" href="https://opencollective.com/megabytelabs" target="_blank">
    <img alt="Open Collective sponsors" src="https://img.shields.io/opencollective/sponsors/megabytelabs?logo=opencollective&label=OpenCollective&logoColor=white&style=for-the-badge" />
  </a>
  <a title="Support us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
    <img alt="GitHub sponsors" src="https://img.shields.io/github/sponsors/ProfessorManhattan?label=GitHub%20sponsors&logo=github&style=for-the-badge" />
  </a>
  <a title="Follow us on GitHub" href="https://github.com/ProfessorManhattan" target="_blank">
    <img alt="GitHub: ProfessorManhattan" src="https://img.shields.io/github/followers/ProfessorManhattan?style=social" target="_blank" />
  </a>
  <a title="Follow us on Twitter" href="https://twitter.com/MegabyteLabs" target="_blank">
    <img alt="Twitter: MegabyteLabs" src="https://img.shields.io/twitter/url/https/twitter.com/MegabyteLabs.svg?style=social&label=Follow%20%40MegabyteLabs" />
  </a>
</div>

> </br><h4 align="center">**An Ansible role that installs Android Studio and sets up Android SDKs on nearly any OS**</h4></br>

<!--TERMINALIZE![terminalizer_title](https://gitlab.com/megabyte-labs/ansible-roles/androidstudio* **github**: /raw/master/.demo.gif
* **gitlab**: /-/raw/master/.demo.gif)TERMINALIZE-->

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Variables](#variables)
  - [Variable Examples](#variable-examples)
    - [`android_sdks`](#android_sdks)
    - [`sdk_location`](#sdk_location)
    - [`user_configs`](#user_configs)
- [Supported Operating Systems](#supported-operating-systems)
- [Dependencies](#dependencies)
  - [Galaxy Roles](#galaxy-roles)
  - [Galaxy Collections](#galaxy-collections)
- [Example Playbook](#example-playbook)
  - [Real World Example](#real-world-example)
- [Contributing](#contributing)
- [License](#license)

<a href="#overview" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Overview

This repository is the home of an [Ansible](https://www.ansible.com/) role that installs Android Studio and sets up Android SDKs on nearly any OS. [Android Studio](https://developer.android.com/studio) is the official integrated development environment for Google's Android operating system, built on JetBrains' IntelliJ IDEA software and designed specifically for Android development. This role installs Android Studio on nearly any operating system and also ensures a configurable list of command-line tools and SDKs are installed and seamlessly integrated with the system (i.e. the role adds items to the `PATH`).

<a href="#features" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Features

**Ensures Android Studio is installed:**

- Installs Android Studio on Archlinux, CentOS, Debian, Fedora, macOS, Ubuntu, and Windows
- Ensures command-line tools are downloaded, installed, and available in the `PATH`

**Ensures configured Android SDKs are present:**

- Installs a configurable list of Android SDKs and Tools to user(s) home folder(s)
- Ensures Android SDK tools like `adb` are present in PATH
- Updates `~/.bashrc` to include SDK tools in `PATH` on Linux systems
- Updates `~/.zshrc` to include SDK tools in `PATH` on Linux systems
- Updates `PATH` on Windows systems

<a href="#quick-start" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Quick Start

Looking to install Android Studio without having to deal with [Ansible](https://www.ansible.com/)? Simply run the following command that correlates to your operating system:

**Linux/macOS:**

```shell
curl -sS https://install.doctor/androidstudio | bash
```

**Windows:**

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/androidstudio?os=win'))
```

**Important Note:** _Before running the commands above you should probably directly access the URL to make sure the code is legit. We already know it is safe but, before running any script on your computer, you should inspect it._

You can also check out **[Install Doctor](https://install.doctor)**. It is an app we created that can install any Ansible role with a one-liner. It has some other nifty features too like the ability to install binaries on-the-fly without requiring a password. However, if you would like to incorporate this role into an Ansible playbook (and customize settings) then please continue reading below.

<a href="#variables" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Variables

This role contains variables that you can customize. The variables you can customize are located in `defaults/main.yml`. By default, the variables use sensible defaults but you may want to customize the role depending on your use case. The variables, along with descriptions, are listed below:

| Name                            | Default Value | Description                                                                                                                                                                                                                                                                                                                                                                                                                |
| ------------------------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`android_sdks`](#android_sdks) | `[]`          | The list of SDKs and tools to install after Android Studio is installed. If no value is provided, the latest version of the SDKs and tools will be installed. Use the correct format, which can be found by executing `sdkmanage --list` after the CLI tools are installed; some package need a version to be specified and some do not.                                                                                   |
| [`sdk_location`](#sdk_location) | `""`          | The folder to set as the SDK location                                                                                                                                                                                                                                                                                                                                                                                      |
| [`user_configs`](#user_configs) | `[]`          | The `user_configs` variable is an array of objects that should, at the very least have the `username` property defined for each user with a home directory that you would like this role to install the Android SDK tools into. If the system property is set to true, then the SDK tools will not be installed to that user's home directory. You can control the installation location with the `sdk_location` variable. |

### Variable Examples

#### `android_sdks`

```yaml
#💬 Example implementation of the android_sdks variable
android_sdks:
  - platform-tools
  - emulator
  - build-tools;30.0.0
  - platforms;android-30
  - sources;android-30
  - patcher;v4
```

#### `sdk_location`

```yaml
#💬 Example implementation of the sdk_location variable
sdk_location: ~/Android/Sdk
```

#### `user_configs`

```yaml
#💬 Example implementation of the user_configs variable
user_configs:
  - username: myuser
  - username: root
    system: true
```

<a href="#supported-operating-systems" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Supported Operating Systems

The chart below shows the operating systems that we have tested this role on. It is automatically generated using the Ansible Molecule tests located in the `molecule/` folder. There is CI logic in place to automatically handle the testing of Windows, macOS, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it is possible that the role will still work.

| OS Family | OS Version            | Status                       | Idempotent                   | Tested On        |
| --------- | --------------------- | ---------------------------- | ---------------------------- | ---------------- |
| Debian    | 10 (Buster)           | <div align="center">✅</div> | <div align="center">❌</div> | August 5th, 2021 |
| Ubuntu    | 18.04 (Bionic Beaver) | <div align="center">✅</div> | <div align="center">❌</div> | August 5th, 2021 |
| Ubuntu    | 20.04 (Focal Fossa)   | <div align="center">✅</div> | <div align="center">❌</div> | August 5th, 2021 |
| Ubuntu    | 21.04 (Hirsute Hippo) | <div align="center">✅</div> | <div align="center">❌</div> | August 5th, 2021 |

**_What does idempotent mean?_** Idempotent means that if you run this role twice in row then there will be no changes to the system the second time around.

We spent a lot of time perfecting our CI configurations and build tools. If you are interested in learning more about how we perfected our process then you might find our [Ansible common files](https://gitlab.com/megabyte-labs/common/ansible) and [Ansible documentation](https://gitlab.com/megabyte-labs/documentation/ansible) repositories interesting. There is more documentation in these repositories.

<a href="#dependencies" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Dependencies

Most of our roles rely on [Ansible Galaxy](https://galaxy.ansible.com) collections. Some of our projects are also dependent on other roles and collections that are published on Ansible Galaxy. Before you run this role, you will need to install the collection and role dependencies, as well as the Python requirements, by running:

```yaml
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
```

Alternatively, you can simply run `bash .start.sh` if you are new to Ansible and do not mind the development requirements also being installed.

### Galaxy Roles

Although most of our roles do not have dependencies, there are some cases where another role has to be installed before the logic can continue. At the beginning of the play, the Ansible Galaxy role dependencies listed in `meta/main.yml` will run. These dependencies are configured to only run once per playbook. If you include more than one of our roles in your playbook that have dependencies in common then the dependency installation will be skipped after the first run. Some of our roles also utilize helper roles directly from the task files which helps keep our [main playbook](repository.playbooks) DRY.

The `requirements.yml` file contains a full list of the Ansible Galaxy dependencies required by this role (i.e. `meta/main.yml` role dependencies, helper roles, collections, etc.). For your convenience, a list of the role dependencies along with quick descriptions is below:

role_dependencies

### Galaxy Collections

This role is dependent on multiple Ansible Galaxy collections. The collections along with a links to their source are listed below.

- <a href="https://galaxy.ansible.com/chocolatey/chocolatey" title="chocolatey.chocolatey collection on Ansible Galaxy" target="_blank"><img alt="chocolatey.chocolatey Ansible Galaxy badge" src="https://img.shields.io/badge/Ansible%20Galaxy-chocolatey.chocolatey-000000?logo=ansible&logoColor=white&style=for-the-badge"></a>
- <a href="https://galaxy.ansible.com/community/general" title="community.general collection on Ansible Galaxy" target="_blank"><img alt="community.general Ansible Galaxy badge" src="https://img.shields.io/badge/Ansible%20Galaxy-community.general-000000?logo=ansible&logoColor=white&style=for-the-badge"></a>

<a href="#example-playbook" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Example Playbook

With the dependencies installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior so you can simply add the role to your playbook without having to worry about commands that should not be run as root:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.androidstudio
```

If you are incorporating this role into a pre-existing playbook, then it might be prudent to copy the requirements in `requirements.txt` and `requirements.yml` to their corresponding files in the root of your playbook so you only have to worry about installing one set of requirements during future use.

### Real World Example

You can find an example of a playbook that incorporates this role in our main playbook (a.k.a. [Windows 12](https://gitlab.com/InstallDoc/ansible-playbook-boilerplate)). The playbook is an excellent example for someone learning how to use Ansible. It also incorporates a lot of well-thought out build tools that more advanced Ansible users can appreciate. And people who could care less about Ansible can also benefit from it because it allows you to more or less turn your computer (and network) into the ultimate development enivornment. The bottom line is that it is an awesome project that developers should know about!

<a href="#contributing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/ProfessorManhattan/ansible-androidstudio/issues). If you would like to contribute, please take a look at the [contributing guide](https://github.com/ProfessorManhattan/ansible-androidstudio/blob/master/CONTRIBUTING.md).

<details>
<summary><b>Sponsorship</b></summary>
<br/>
<blockquote>
<br/>
Dear Lovely Person,<br/><br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a href="ProfessorManhattan">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

</details>

<a href="#license" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## License

Copyright © 2020-2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](https://gitlab.com/megabyte-labs/ansible-roles/androidstudio/-/blob/master/LICENSE) licensed.
