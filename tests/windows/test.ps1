# @file tests/windows/test.ps1
# @brief Runs an Ansible play on a GitLab CI shared Windows runner
#
# @description
# This PowerShell script prepares a GitLab CI shared Windows runner to test an
# Ansible play for Windows compatibility. Since Ansible cannot run on Windows,
# it uses Docker to run the play on the Windows host. Both Chocolatey and Docker
# come preinstalled on the shared runner. The script performs the following tasks
# in order:
#
# 1. Installs Python 3 via Chocolatey
# 2. Changes the administrator password to AnsibleTest999 since it is unknown
# 3. Sets up WinRM CredSSP which Ansible connects with since SSH is currently not a viable option for
#    connecting to the Windows host from a child Docker container. The script this step uses is an
#    official example of how to set up WinRM on Windows for Ansible.
# 4. Runs the Ansible play via Docker which then performs the remaining steps by running a seperate shell script.
#
# This script is called by a [GitLab CI job](https://gitlab.com/megabyte-labs/ci/gitlab-ci-templates/-/blob/master/test/windows-ansible.gitlab-ci.yml).

Write-Host "Installing Python 3 via Chocolatey and adding it to the PATH"
choco install python3 --params "/InstallDir:C:\Python3" -y
$env:PATH+=";C:\Python3;C:\Python3\Scripts"

Write-Host "Changing $env:UserName password to 'AnsibleTest999'"
$NewPassword = ConvertTo-SecureString "AnsibleTest999" -AsPlainText -Force
Set-LocalUser -Name $env:UserName -Password $NewPassword

Write-Host "Setting up WinRM CredSSP"
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
PowerShell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth

Write-Host "Running the Ansible play on the local machine via a Docker container with Ansible"
$CurrentLocation = Get-Location
$WorkDirectory = Split-Path -leaf -path (Get-Location)
$HostIP = (Get-NetIPConfiguration | Where-Object -Property IPv4DefaultGateway).IPv4Address.IPAddress
docker run -it -v $("$($CurrentLocation)"+':/'+$WorkDirectory) -w $('/'+$WorkDirectory) `
--add-host='windows-docker:'$HostIP --entrypoint /bin/sh megabytelabs/ansible:slim ./tests/windows/test.sh
