<a id="readme-top"></a>


## Running DFIR-Deployment Prerequisites:

To run DFIR-Deployment-Enhancedv6.ps1 the follow prerequisites must be created and input:

1. Open EncryptCredentialsV1.ps1 and update the pathway for the following to a valid filepath. This will create the credential file for the DFIR script to reference. Run this script.
  ```sh
  $Credential | Export-Clixml -Path "C:\Pathway\ToConfig\Config.xml"
  ```

2. Open DFIR-Deploymentv5.ps1 and update the following pathways to valid pathways in your system.
  ```sh
  # This will be the Config file that was created using the above script:
  $ImportCreds = Import-Clixml -Path "C:\Pathway\ToConfig\Config.xml"

  # This will be the OU that your computers are assigned too. Enter in the DistinquishedName.
  # DistinquishedName can be obtained easily on ADSI Edit whilst on your DC.
  $OUComs = Get-ADObject -Identity "OU=Domain Computers,DC=ThroughTheTrees,DC=com"

  # This will be the pathway to your DFIR Scripts:
  $ScriptObjects = "C:\Pathway\ToScripts\ScriptDirectory\"

  # This is where log files will output to:
  $LogPathway = "C:\Pathway\ToLogOutput\"

  ```

3. Create a scheduled task to run DFIR-Deployment.

### Scheduled Task Information:
The scheduled task needs to be configured to the following:

#### General Settings:
1. Run Whether user is logged on or not
2. Run with highest privileges

#### Action Settings:
1. Program/Script: "PowerShell.exe"
2. Add Arguments "-ExecutionPolicy Bypass" -File "C:\Pathway\To\DFIR\DFIR.ps1" -Verb RunAs

#### Condition:
Wake the computer to run this task

#### Settings:
(Optional) Run task as soon as possible after a scheduled start is missed

4. Run the scheduled task. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>
