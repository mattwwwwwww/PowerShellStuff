function Remote-ExecuteDFIR
{
    <#
    .SYNOPSIS
    This script will run the DFIR script against all computers within the selected OU.

    .DESCRIPTION
    This script will output multiple csv files for DFIR which can be injested into a SIEM.

    .EXAMPLE
    Execute the script with Administration Privileges.
    Ensure that an encrypted credential file exists in the location specified in the $InputPathway variable. 

    #>

    $ImportCreds = Import-Clixml -Path "C:\ProgramData\DFIR\EncryptedPasswordFile.xml"

    $OUComs = Get-ADObject -Identity "OU=Domain Computers,DC=ThroughTheTrees,DC=com"
    $MyComs = Get-ADComputer -filter * -SearchBase $OUComs
    $InputPathway = "C:\Users\Matt\Downloads\Incident-Response-Powershell-main\Incident-Response-Powershell-main.ps1"
    $TestPathway = Test-Path -Path $InputPathway

    # Convert the contents of the script to a ScriptBlock variable:
    $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway -Raw))

    Write-Host "DFIR script will run against all of the machines in the OU: $OUComs.Identity" -ForegroundColor red -BackgroundColor White

    if($TestPathway)
    {
        foreach($Com in $MyComs)
        {
            try 
            {
                Write-Verbose "Attempting remote connection to: $Com.Name"
                & Invoke-Command -ComputerName $MyComs.DNSHostName -ScriptBlock $ScriptBlockInput -Credential $ImportCreds -Authentication Credssp
                Write-Host "`nOperation complete for host: $MyComs.DNSHostName`n" -ForegroundColor Red -BackgroundColor White
            }    
            catch 
            {
                $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                Write-Host "Error occured at $TimeStamp"
                Write-Host "Error: $_.Exception"
            }
        }    
    }
    Write-Host "DFIR SCRIPT COMPLETE" -ForegroundColor Red -BackgroundColor White
}
Remote-ExecuteDFIR