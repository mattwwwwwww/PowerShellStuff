function Remote-ExecuteDFIR
{
    try {
        # Specify the pathway to the config file here:
        $ImportCreds = Import-Clixml -Path "C:\PATHWAY\TO\Config.xml"

        # Specify the computers OU for the SearchBase here:
        $MyComs = Get-ADComputer -SearchBase "OU=Domain Computers,DC=Domain ..." -filter * | Where-Object {$_.Name -imatch "WK10"}

        # Specify where your log files will output too:
        $LogPathway = "C:\PATHWAY\TO\LOGFILES\"

        $ScriptObjects = Get-ChildItem -Path "C\ProgramData\DFIR\Core" | Where-Object {$_.Name -imatch "Enhanced-DFIR-Script"}

    }
    catch {
        # Insert catch if required.
    }

    try {
        foreach($Script in $ScriptObjects) {
            $InputPathway = $Script.FullName
            $TestPath = Test-Path $InputPathway

            if($TestPath){
                $ScriptBlockInput = [scriptblock]::Create((Get-Content $InputPathway -Raw))
                Write-Host "Commencing Script:" $Script.FullName -ForegroundColor red -BackgroundColor white

                $Sessions = @()
                foreach($Com in $MyComs) {
                    $Sessions += New-PSSession -ComputerName $Com.DNSHostName -Credential $ImportCreds
                }

                foreach ($Session in $Sessions)
                {
                    try {
                        Write-Verbose "Attempting remote connections to: " + $Com.Name
                        Invoke-Command -Session $Session -ScriptBlock $ScriptBlockInput -AsJob -JobName $Session.ComputerName
                    }
                    catch {
                        $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                        Write-Host "Error occured at $TimeStamp"
                        Write-Host "Error: $_.Exception"
                    }
                }
            # Get all the PowerShell jobs here:
            $PSJobs = Get-Job

            $KillTask = Get-Date

            #This while loop will check if the PowerShell jobs running in the background are complete:
            while ($PSJobs.State -contains "Running") {
                # Loop will break when jobs are finished:
                if($KillTask -eq ($KillTask.AddHours(2))){
                    Get-Job | Stop-Job
                }
            }

            foreach($Job in $PSJobs){
                if($Job.State -ne "Running"){
                    $Ans = Receive-Job -Name $Job.Name
                    $Ans | Out-File -FilePath ($LogPathway + $Job.Name + "_" + $Job.PSEndTime.ToString("yyyyMMdd:HHmmss") + "_ConsoleOutput.txt")
                    Write-Host "The job for:" $Job.Name "is completed" -ForegroundColor red -BackgroundColor White
                }
            }
            Write-Host "DFIR SCRIPT: " $Script.FullName "Completed" -ForegroundColor red -BackgroundColor White
            $PSJobs | Where-Object { $_.State -eq "Failed"} | Out-File ($LogPathway + (Get-Date).ToString("yyyyMMdd_HHmmss") + "_FailedJobs.txt")
            Get-Job | Remove-Job
            }
        }
    }
    catch {
        Write-Output "An Error Occured: " + $_
        $_ | Out-File -FilePath ($LogPathway + "DFIR-Deployment" + (Get-Date).ToString("yyyyMMdd_HHmmss") + "_Errors.txt")
    }
    finally{
        foreach($Session in $Sessions){
            & Copy-Item -FromSession $Session -Path "C:\ProgramData\Results\" -Recurse -Destination ("C:\ProgramData\DFIR\Results\") + $Session.ComputerName.Split("."[0]) + "_" + (Get-Date).ToString("yyyyMMdd_HHmmss")
            Invoke-Command -Session $Session -ScriptBlock {Remove-Item -Path "C:\ProgramData\Results" -Force -Recurse}
        }
        Get-Job | Stop-Job
        Get-Job | Remove-Job
        Get-PSSession | Remove-PSSession
    }

}