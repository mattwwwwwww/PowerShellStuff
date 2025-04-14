<a id="readme-top"></a>


## Running DFIR-Deployment Prerequisites:

To run DFIR-Deploymentv5.ps1 the follow prerequisites must be created and input:

1. Open EncryptCredentialsV1.ps1 and update the pathway for the following to a valid filepath. This will create the credential file for the DFIR script to reference. Run this script.
* npm
  ```sh
  $Credential | Export-Clixml -Path "C:\Pathway\ToConfig\Config.xml"
  ```

2. Open DFIR-Deploymentv5.ps1 and update the following pathways to valid pathways in your system.
  * npm
  ```sh
  # This will be the Config file that was created using the above script:
  $ImportCreds = Import-Clixml -Path "C:\PATHWAY\TO\Config.xml"

  # This will be the OU that your computers are assigned too. Enter in the DistinquishedName:
  $OUComs = Get-ADObject -Identity "OU=Domain Computers,DC=ThroughTheTrees,DC=com"

  # This will be the pathway to your DFIR Script:
  $InputPathway = "C:\PATHWAY\TO\DFIR-Script.ps1"

  # This is where log files will output to:
  $LogPathway = "C:\PATHWAY\TO\LOGFILES\"

  ```

3. Create a scheduled task to run DFIR-Deployment.

### Scheduled Task Information:
The scheduled task needs to be configured to the following:

#### General Settings:
Run Whether user is logged on or not
Run with highest privileges

#### Action Settings:
Program/Script: "PowerShell.exe"
Add Arguments "-ExecutionPolicy Bypass" -File "C:\Pathway\To\DFIR\DFIR.ps1" -Verb RunAs

#### Condition:
Wake the computer to run this task

#### Settings:
(Optional) Run task as soon as possible after a scheduled start is missed

4. Run the scheduled task. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>