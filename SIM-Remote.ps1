    
function Remote-ExecuteDFIR
{
    <#
    .SYNOPSIS
    This script will run the DFIR script against all computers within the selected OU.

    .DESCRIPTION
    This script will output multiple csv files for DFIR which can be injested into a SIEM.

    .EXAMPLE
    Confirm the filepath of the DFIR script and folders within exist. 
    Run the script as administrator.
    Enter a valid admin account with PSRemoting permissions.
    PS> Remote-ExecuteDFIR  
    #>

    Write-Host "Please enter in the Password to encrypt:"
    $Pass = Read-Host -AsSecureString

    Write-Host "Enter the DOMAIN\USERNAME of the user creating a PS Remote session:"
    $Username = Read-Host 
    $Credentials = New-Object System.Management.Automation.PSCredential($Username, $Pass)


    $OUComs = Get-ADObject -Identity "OU=Domain Computers,DC=ThroughTheTrees,DC=com"
    $MyComs = Get-ADComputer -filter * -SearchBase $OUComs
    $TestPath = Test-Path -Path "C:\Users\Matt\Downloads\Incident-Response-Powershell-main\Incident-Response-Powershell-main"

    if($TestPath)
    {
        foreach($Com in $MyComs)
        {
            try 
            {
                #DNSHostName
                Write-Verbose "Attempting remote connection to: $Com.Name"
                $RemoteSession = New-PSSession -ComputerName $Com.DNSHostName -Credential $Credentials -ErrorAction Stop
        
                Write-Verbose "Running commands via a remote session to $Computer.Name"
                & Invoke-Command -Session $RemoteSession -FilePath "C:\Users\Matt\Downloads\Incident-Response-Powershell-main\Incident-Response-Powershell-main\DFIR-Script.ps1" -ErrorAction Stop
            }    
            catch 
            {
                $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                Write-Host "Error occured at $TimeStamp"
                Write-Host "Error: $_.Exception.Message"
            }
        }    
    }
    Write-Host "DFIR SCRIPT COMPLETE"
}
Remote-ExecuteDFIR

