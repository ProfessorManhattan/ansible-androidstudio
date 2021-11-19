<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-readme-role.md" ⚠️-->{{ load:.common/docs/common/readme/header.md }}

{{ load:.common/docs/readme-role/subheader.md }}
{{ load:.common/docs/readme-role/quick-description.md }}

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Features](#features)
- [Variables](#variables)
  _ [`android_sdks`](#android_sdks)
  _ [`sdk_location`](#sdk_location)
  _ [`user_configs`](#user_configs)
  _ [Galaxy Collections](#galaxy-collections)
  {{ load:.common/docs/readme-role/overview.md }}

<a href="#features" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Features

**Ensures Android Studio is installed:**

- Installs Android Studio on Archlinux, CentOS, Debian, Fedora, macOS, Ubuntu, and Windows
- Ensures command-line tools are downloaded, installed, and available in the `PATH`

**Ensures configured Android SDKs are present:**

- Installs a configurable list of Android SDKs and Tools to user(s) home folder(s)
- Ensures Android SDK tools like `adb` are present in PATH
- Updates `PATH` on Windows systems
- Updates `~/.bashrc` to include SDK tools in `PATH` on Linux systems
- Updates `~/.zshrc` to include SDK tools in `PATH` on Linux systems
  {{ load:.common/docs/readme-role/quick-start.md }}

<a href="#variables" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Variables

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

{{ load:.common/docs/readme-role/supported-os.md }}
{{ load:.common/docs/readme-role/dependencies.md }}

### Galaxy Collections

This role is dependent on multiple Ansible Galaxy collections. The collections along with a links to their source are listed below.

- <a href="https://galaxy.ansible.com/chocolatey/chocolatey" title="chocolatey.chocolatey collection on Ansible Galaxy" target="_blank"><img alt="chocolatey.chocolatey Ansible Galaxy badge" src="https://img.shields.io/badge/Ansible%20Galaxy-chocolatey.chocolatey-000000?logo=ansible&logoColor=white&style=for-the-badge"></a>
- <a href="https://galaxy.ansible.com/community/general" title="community.general collection on Ansible Galaxy" target="_blank"><img alt="community.general Ansible Galaxy badge" src="https://img.shields.io/badge/Ansible%20Galaxy-community.general-000000?logo=ansible&logoColor=white&style=for-the-badge"></a>

{{ load:.common/docs/readme-role/example.md }}

{{ load:.common/docs/common/readme/contribute.md }}

{{ load:.common/docs/common/readme/license.md }}
