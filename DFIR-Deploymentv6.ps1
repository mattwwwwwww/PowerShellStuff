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
    If a valid config file doesn't exist, you can create one with the "SecureConfig.ps1" script.
    PS> DFIR-Deploymentv5.ps1
    #>

    # Specify the pathway to the config file here:
    $ImportCreds = Import-Clixml -Path "C:\PATHWAY\TO\Config.xml"

    # Specify the OU containing the computers you wish to run the script against here:
    $OUComs = Get-ADObject -Identity "OU=Domain Computers,DC=ThroughTheTrees,DC=com"
    $MyComs = Get-ADComputer -filter * -SearchBase $OUComs

    # Specify the Pathway's to the DFIR Script here: 
    $InputPathway1 = "C:\PATHWAY\TO\DFIR-Script1.ps1"
    $InputPathway2 = "C:\PATHWAY\TO\DFIR-Script2.ps1"
    $InputPathway3 = "C:\PATHWAY\TO\DFIR-Script3.ps1"
    $InputPathway4 = "C:\PATHWAY\TO\DFIR-Script4.ps1"

    # Testing the pathways exist here:
    $TestPathway1 = Test-Path -Path $InputPathway1
    $TestPathway2 = Test-Path -Path $InputPathway2
    $TestPathway3 = Test-Path -Path $InputPathway3
    $TestPathway4 = Test-Path -Path $InputPathway4

    # Specify the pathway to where log files will output:
    $LogPathway = "C:\PATHWAY\TO\LOGFILES\"
    
    Write-Host "DFIR script will run against all of the machines in the OU: $OUComs.Identity" -ForegroundColor red -BackgroundColor White
    Write-Host "Commencing script 1:" -ForegroundColor red -BackgroundColor White

    # Convert the contents of the script to a ScriptBlock variable:
    $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway1 -Raw))

    if($TestPathway1)
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
    


    Write-Host "Commencing script 2:" -ForegroundColor red -BackgroundColor White

    # Convert the contents of the script to a ScriptBlock variable:
    $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway2 -Raw))

    if($TestPathway2)
    {
        foreach($Com in $MyComs)
        {
            try 
            {
                Write-Verbose "Attempting remote connection to: $Com.Name"
                Invoke-Command -ComputerName $Com.DNSHostName -ScriptBlock $ScriptBlockInput -Credential $ImportCreds -Authentication Credssp -AsJob -JobName $MyComs.DNSHostName 
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



    Write-Host "Commencing script 3:" -ForegroundColor red -BackgroundColor White

    # Convert the contents of the script to a ScriptBlock variable:
    $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway3 -Raw))

    if($TestPathway3)
    {
        foreach($Com in $MyComs)
        {
            try 
            {
                Write-Verbose "Attempting remote connection to: $Com.Name"
                Invoke-Command -ComputerName $Com.DNSHostName -ScriptBlock $ScriptBlockInput -Credential $ImportCreds -Authentication Credssp -AsJob -JobName $MyComs.DNSHostName 
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



    Write-Host "Commencing script 4:" -ForegroundColor red -BackgroundColor White

    # Convert the contents of the script to a ScriptBlock variable:
    $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway4 -Raw))

    if($TestPathway4)
    {
        foreach($Com in $MyComs)
        {
            try 
            {
                Write-Verbose "Attempting remote connection to: $Com.Name"
                Invoke-Command -ComputerName $Com.DNSHostName -ScriptBlock $ScriptBlockInput -Credential $ImportCreds -Authentication Credssp -AsJob -JobName $MyComs.DNSHostName 
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
Remote-ExecuteDFIR
