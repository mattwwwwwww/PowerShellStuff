function Remote-ExecuteDFIR
{
    <#
    .SYNOPSIS
    This script will run the DFIR script against all computers within the selected OU.

    .DESCRIPTION
    This script will output multiple JSON files for DFIR which can be injested into a SIEM.

    .EXAMPLE
    Execute the script with Administration Privileges.
    Ensure that an encrypted credential file exists in the location specified in the $InputCreds variable.
    Ensure that all necessary filepaths are hard coded. 
    If a valid config file doesn't exist, you can create one with the "EncryptCredentialsV1.ps1" script.
    PS> DFIR-Deploymentv5.ps1
    #>

    # Specify the pathway to the config file here:
    $ImportCreds = Import-Clixml -Path "C:\PATHWAY\TO\Config.xml"

    # Specify the OU containing the computers you wish to run the script against here:
    $OUComs = Get-ADObject -Identity "OU=Domain Computers,DC=ThroughTheTrees,DC=com"
    $MyComs = Get-ADComputer -filter * -SearchBase $OUComs

    # Specify the pathway to where log files will output:
    $LogPathway = "C:\PATHWAY\TO\LOGFILES\"

    $ScriptObjects = Get-ChildItem -Path "C\ProgramData\DFIR\Core" | Where-Object {$_.Name -imatch "Enhanced-DFIR-Script"}

    foreach($Script in $ScriptObjects)
    {
        $InputPathway = $Script.FullName
        $TestPath = Test-Path $InputPathway

        # Convert the contents of the script to a ScriptBlock variable:
        $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway -Raw))
        Write-Host "Commencing Script:" $Script.FullName -ForegroundColor red -BackgroundColor white
        Write-Host "DFIR script will run against OU:" $OUComs.Identity -ForegroundColor red -BackgroundColor white

        if($TestPath)
        {
            foreach($Com in $MyComs)
            {
                try 
                {
                    Write-Verbose "Attempting remote connection to: $Com.Name"
                    Invoke-Command -ComputerName $Com.DNSHostName -ScriptBlock $ScriptBlockInput -Credential $ImportCreds -Authentication Credssp -AsJob -JobName $Com.DNSHostName 
                }    
                catch 
                {
                    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    Write-Host "Error occured at $TimeStamp"
                    Write-Host "Error: $_.Exception"
                }
            }
            # Get all the PowerShell jobs here:
            $PSJobs = Get-Job
            
            while($PSJobs.State -contains "Running") 
            {
                # Loop will break when all jobs are complete
            }

            foreach($Job in $PSJobs)
            {
                if($Job.State -eq "Completed")
                {
                    $Ans = Receive-Job -Name $Job.Name
                    $Ans | Out-File -FilePath ($LogPathway + $Job.Name + "_" + $Job.PSEndTime.ToString("yyyyMMdd:HHmmss") + "_ConsoleOutput.txt")
                    Write-Host "The job for:" $Job.Name "is completed" -ForegroundColor red -BackgroundColor White
                }
            }
            $PSJobs | Where-Object -eq "Failed" | Out-file ($LogPathway + (Get-Date).ToString("yyyyMMdd_HHmmss") + "_FailedJobs.txt")
            Write-Host "DFIR SCRIPT COMPLETE" -ForegroundColor Red -BackgroundColor White
            Get-Job | Remove-Job
        }
        
    }

}
