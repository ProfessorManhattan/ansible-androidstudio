## Quick Start

The easiest way to run the entire playbook, outlined in the `main.yml` file, is to run the appropriate command listed below. These commands will run the playbook on the machine you run the command on. This is probably the best way to get your feet wet before you decide to give us a ⭐ and customize the playbook for your own needs. Ideally, this command should be run on the machine that you plan on running Ansible with to provision the other computers on your network. It is only guaranteed to work on fresh installs.

#### macOS/Linux

```shell
curl -sS https://install.doctor/playbook | bash
```

#### Windows

In an administrative PowerShell session, run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://install.doctor/playbook?os=win'))
```
