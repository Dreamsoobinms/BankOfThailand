*** Settings ***
Library    Process

*** Variables ***
${CERT_PATH}                //bot.or.th/cfs/FILESERV/QMDataFile/FIN1/SCB Cert/SCB-1.p12
${PASSWORD}                 1234zZ
${THUMBPRINT}               E47BD149C8655112D11C48F242E3856FF4D536CF

*** Test Cases ***
# PowerShell Remove Certificate: Set-Location Cert:\CurrentUser\My; Get-ChildItem | Where-Object {$_.Thumbprint -eq "E47BD149C8655112D11C48F242E3856FF4D536CF"} | Remove-Item
# PowerShell Add Certificate: $password = ConvertTo-SecureString -String "1234zZ" -AsPlainText -Force; Import-PfxCertificate -FilePath "\\bot.or.th\cfs\FILESERV\QMDataFile\FIN1\SCB Cert\SCB-1.p12" -CertStoreLocation Cert:\CurrentUser\My -Password $password
# Run Process: Executes the PowerShell script using powershell.exe. The Start-Process cmdlet is used to run PowerShell with administrative privileges (-Verb RunAs). The -ArgumentList parameter passes the necessary arguments to the script.

5.1.10 สร้าง script สำหรับการ add/remove certificate โดย Powershell ระบบ ที่ใช้ Certificate
    Add Certificate
    Remove Certificate

*** Keywords ***
Add Certificate
    [Documentation]    Add a certificate with a passphrase
    Run Process    powershell.exe    -Command    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "$password \= ConvertTo-SecureString -String ''${PASSWORD}'' -AsPlainText -Force; Import-PfxCertificate -FilePath ''${CERT_PATH}'' -CertStoreLocation Cert:/CurrentUser/My -Password $password -Verbose;"' -Verb RunAs

Remove Certificate
    [Documentation]    Remove a certificate using its thumbprint
    Run Process    powershell.exe    -Command    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "Set-Location Cert:/CurrentUser/My; Get-ChildItem | Where-Object {$_.Thumbprint -eq ''${THUMBPRINT}''} | Remove-Item -Verbose;"' -Verb RunAs


