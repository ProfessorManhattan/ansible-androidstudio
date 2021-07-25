# Ansible Role: androidstudio

## Actions:

Actions performed by this role

#### Ensures Android Studio is installed:

- Installs Android Studio on Archlinux, CentOS, Debian, Fedora, macOS, Ubuntu, and Windows
- Installs a configurable list of Android SDKs and Tools

#### Ensures configured Android SDKs are present:

- Ensures Android SDK tools like `adb` are present in PATH

## Tags:

## Variables:

- `android_sdks`: `[]` - The list of SDKs and Tools to install after Android Studion is installed. If no value is provided, the latest version of the SDKs and Tools will be installed. Use the correct format, which can be found by executing `sdkmanage --list` once the commandline-tools is installed; some package need a version to be specified and some do not.

example:

```yaml
android_sdks:
  - platform-tools
  - emulator
  - build-tools;30.0.0
  - platforms;android-30
  - sources;android-30
  - patcher;v4
```

- `sdk_location`: `""` - The folder to set as the SDK Location

example:

```yaml
sdk_location: ~/Android/Sdk
```

Documentation generated using: [Ansible-autodoc](https://github.com/AndresBott/ansible-autodoc)
