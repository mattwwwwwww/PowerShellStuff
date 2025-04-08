
# Funky shit to get the sessions going -- Dub03 -- Moving to an OU: 

# PATH TO DOMAIN COMPUTERS: OU=Domain Computers,DC=ThroughTheTrees,DC=com

$AllComs = Get-ADComputer -Filter *
$Creds = Get-Credential

foreach ($Computer in $AllComs)
{
    Write-Verbose "Attempting remote connection to: $Computer.Name"
    $RemoteSession = New-PSSession -ComputerName $Computer.DNSHostName -Credential $Creds

    Write-Verbose "Running commands via a remote session to $Computer.Name"
    Invoke-Command -Session $RemoteSession -FilePath "C:\Users\Matt\Downloads\Incident-Response-Powershell-main\Incident-Response-Powershell-main" 
}

Remove-Variable -Name Creds