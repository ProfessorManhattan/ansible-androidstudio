winrm get winrm/config
Get-Service WinRM

docker images

#Write-Host "Setting up WinRM"
#$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
#$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
#(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
#powershell.exe -ExecutionPolicy ByPass -File $file -EnableCredSSP -DisableBasicAuth | Out-Null

Write-Host "Changing user password to 'AnsibleTest999'"
$NewPassword = ConvertTo-SecureString "AnsibleTest999" -AsPlainText -Force
Set-LocalUser -Name $env:UserName -Password $NewPassword
Write-Host "Changed..."

Write-Host "Running the Ansible play on the local machine via a Docker container with Ansible"
$CurrentLocation = Get-Location
$WorkDirectory = Split-Path -leaf -path (Get-Location)
$HostIP = (Get-NetIPConfiguration | Where-Object -Property IPv4DefaultGateway).IPv4Address.IPAddress
docker run -it -v $("$($CurrentLocation)"+':/'+$WorkDirectory) -w $('/'+$WorkDirectory) `
--add-host='windows-docker:'$HostIP --entrypoint /bin/sh megabytelabs/ansible:slim ./tests/windows/test.sh
