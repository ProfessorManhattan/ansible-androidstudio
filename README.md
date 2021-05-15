<!-- ⚠️ This README has been generated from the file(s) "./.modules/docs/blueprint-readme.md" ⚠️-->

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#ansible-role--role_pretty_name-)

# ➤ Ansible Role: Android Studio

<h4>
  <a href="https://gitlab.com/ProfessorManhattan/Playbooks">Main Playbook</a>
  <span> | </span>
  <a href="https://galaxy.ansible.com/professormanhattan/androidstudio">Galaxy</a>
  <span> | </span>
  <a href="https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/blob/master/CONTRIBUTING.md">Contributing</a>
  <span> | </span>
  <a href="https://app.slack.com/client/T01ABCG4NK1/C01NN74H0LW/details/">Chat</a>
  <span> | </span>
  <a href="https://megabyte.space">Website</a>
</h4>
<p>
  <a href="https://gitlab.com/megabyte-space/ansible-roles/androidstudio">
    <img alt="Version" src="https://img.shields.io/badge/version-0.0.1-blue.svg?cacheSeconds=2592000" />
  </a>
  <a href="https://megabyte.space/docs/androidstudio" target="_blank">
    <img alt="Documentation" src="https://img.shields.io/badge/documentation-yes-brightgreen.svg" />
  </a>
  <a href="repository.gitlab_ansible_roles_group/androidstudio/-/raw/master/LICENSE" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/PrfssrManhattan" target="_blank">
    <img alt="Twitter: PrfssrManhattan" src="https://img.shields.io/twitter/url/https/twitter.com/PrfssrManhattan.svg?style=social&label=Follow%20%40PrfssrManhattan" />
  </a>
  <a href="">
    <img alt="macOS build status" src="https://img.shields.io/github/checks-status/MegabyteLabs/github_link/master?color=cyan&label=macOS%20Build%20Status&logo=apple&style=for-the-badge">
  </a>
  <a href="">
    <img alt="Windows 10 build status" src="https://img.shields.io/github/checks-status/MegabyteLabs/github_link/master?color=cyan&label=Windows%20Build%20Status&logo=windows&style=for-the-badge">
  </a>
  <a href="">
    <img alt="Linux build status" src="https://img.shields.io/github/checks-status/MegabyteLabs/github_link/master?color=cyan&label=Windows%20Build%20Status&logo=windows&style=for-the-badge">
  </a>
</p>

> </br>**An Ansible role that installs Android Studio on nearly any OS**</br></br>

![terminalizer_title](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/raw/master/.demo.gif)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#table-of-contents)

## ➤ Table of Contents

- [➤ Ansible Role: Android Studio](#-ansible-role-android-studio)
  - [➤ Overview](#-overview)
  - [➤ Supported Operating Systems](#-supported-operating-systems)
  - [➤ Dependencies](#-dependencies)
    - [Galaxy Roles](#galaxy-roles)
  - [➤ Example Playbook](#-example-playbook)
  - [➤ Contributing](#-contributing)
  - [➤ License](#-license)

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#overview)

## ➤ Overview

This repository contains an Ansible role that will install Android Studio on nearly any OS. Android Studio is the official integrated development environment for Google's Android operating system, built on JetBrains' IntelliJ IDEA software and designed specifically for Android development.

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#supported-operating-systems)

## ➤ Supported Operating Systems

The following chart shows the operating systems that have been tested for compatibility using the `environments/dev/` environment. This chart is automatically generated using the Ansible Molecule tests you can view in the `molecule/default/` folder. We currently have logic in place to automatically handle the testing of Windows, Mac OS X, Ubuntu, Fedora, CentOS, Debian, and Archlinux. If your operating system is not listed but is a variant of one of the systems we test (i.e. a Debian-flavored system or a RedHat-flavored system) then it might still work.

| OS Family | OS Version | Status | Idempotent |
| --------- | ---------- | ------ | ---------- |
| Fedora    | 33         | ❌     | ❌         |
| Ubuntu    | focal      | ✅     | ❌         |

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#dependencies)

## ➤ Dependencies

Most of our roles rely on [Ansible Galaxy](https://galaxy.ansible.com/) collections. Some of our projects are also dependent on other roles and collections that are published on Ansible Galaxy. Before you run this role, you will need to install the collection and role dependencies (as well as the Python requirements) by running:

```
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
```

### Galaxy Roles

At the beginning of the play, the galaxy role dependencies listed in `meta/main.yml` will run. These dependencies are configured to only run once per playbook. If you include more than one of our roles in your playbook that have dependencies in common then the dependency installation will be skipped after the first run. Some of our roles also utilize helper roles which help keep our [main playbook](https://gitlab.com/ProfessorManhattan/Playbooks) DRY. A full list of the dependencies along with quick descriptions is below:

| Role Dependency                                          | Description                                |
| -------------------------------------------------------- | ------------------------------------------ |
| <a href='https://google.com'>professormanhattan.java</a> | Installs Java on nearly any OS             |
| <a href='https://bing.com'>professormanhattan.snapd</a>  | Ensures Snap is installed on Linux systems |

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#example-playbook)

## ➤ Example Playbook

With the dependencies installed, all you have to do is add the role to your main playbook. The role handles the `become` behavior so you can simply add the role to your playbook without having to worry about commands that should not be run as root:

```lang-yml
- hosts: all
  roles:
    - professormanhattan.androidstudio
```

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#contributing)

## ➤ Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/issues). If you would like to contribute, please take a look at the [contributing guide](https://gitlab.com/megabyte-space/ansible-roles/androidstudio/-/raw/master/CONTRIBUTING.md).

<details>
<summary>Sponsorship</summary>
<br/>
<blockquote>
<br/>
I create open source projects out of love. Although I have a job, shelter, and as much fast food as I can handle, it would still be pretty cool to be appreciated by the community for something I have spent a lot of time and money on. Please consider sponsoring me! Who knows? Maybe I will be able to quit my job and publish open source full time.
<br/><br/>Sincerely,<br/><br/>

**_Brian Zalewski_**<br/><br/>

</blockquote>

<a href="profile.patreon">
  <img src="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png" width="160">
</a>

</details>

[![-----------------------------------------------------](https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/aqua.png)](#license)

## ➤ License

Copyright © 2021 [Megabyte LLC](https://megabyte.space). This project is [MIT](repository.gitlab_ansible_roles_group/androidstudio/-/raw/master/LICENSE) licensed.
