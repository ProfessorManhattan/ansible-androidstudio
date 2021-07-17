Write-Host "Setting up WinRM"
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file -Verbose -EnableCredSSP -DisableBasicAuth

Write-Host "Changing user password to 'AnsibleTest999'"
$NewPassword = ConvertTo-SecureString "AnsibleTest999" –AsPlainText –Force
Set-LocalUser –Name $env:UserName –Password $NewPassword
