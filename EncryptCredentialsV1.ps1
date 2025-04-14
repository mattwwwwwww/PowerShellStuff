# Enter a valid administrator Credential
$Credential = Get-Credential

# By default, The Export-Clixml cmdlet uses the Windows Data Protection API (DPAPI) for encryption. 
# DPAPI uses the users credentials to generate a master key. 
# In order to decrypt the file and adverary would need to secure the file, as well as have access to the generated master key.
# Adversaries can utilize tools like Mimikatz to try and secure the master key. 

$Credential | Export-Clixml -Path "C:\Pathway\ToConfig\Config.xml"