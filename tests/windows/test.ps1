#winrm get winrm/config
#Get-Service WinRM
choco install docker-desktop

docker version
docker images

#Write-Output $PSVersionTable

#Get-ComputerInfo

dir $env:PROGRAMFILES\Docker\Docker
#Write-Output "Setting up WinRM"
#$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
#$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
#(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
#powershell.exe -ExecutionPolicy ByPass -File $file -EnableCredSSP -DisableBasicAuth | Out-Null

Write-Output "Changing user password to 'AnsibleTest999'"
$NewPassword = ConvertTo-SecureString "AnsibleTest999" -AsPlainText -Force
Set-LocalUser -Name $env:UserName -Password $NewPassword

Write-Output "Running the Ansible play on the local machine via a Docker container with Ansible"
$CurrentLocation = Get-Location
$WorkDirectory = Split-Path -leaf -path (Get-Location)
Write-Output $CurrentLocation
Write-Output $WorkDirectory
docker run hello-world

Write-Output "Get Host IP"
Get-NetIPConfiguration
$HostIP = (Get-NetIPConfiguration | Where-Object -Property IPv4DefaultGateway).IPv4Address.IPAddress
Write-Output $HostIP
docker run hello-world

docker run -it -v $("$($CurrentLocation)"+':/'+$WorkDirectory) -w $('/'+$WorkDirectory) `
--add-host='windows-docker:'$HostIP --entrypoint /bin/sh megabytelabs/ansible:slim ./tests/windows/test.sh
