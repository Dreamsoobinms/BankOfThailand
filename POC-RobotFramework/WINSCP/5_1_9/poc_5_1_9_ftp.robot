*** Settings ***
Library         FtpLibrary
Library         Collections

*** Variables ***
${HOST}         efswin-ap1-t1
${PORT}         2121
${USERNAME}     botefscauser
${PASSWORD}     botefscauser
${DIRECTORY}    /PREFUND_DATA
${TIMEOUT}      30

*** Test Cases ***
Verify FTP Connection and Directory
    # Connect FTP protocol with Host, user, password port (timeout and tls is optional)
    FTP CONNECT    ${HOST}    user=${USERNAME}    password=${PASSWORD}    port=${PORT}    timeout=${TIMEOUT}    tls=False
    # log Directory path
    @{dirResult}=    dir
    Log    ${dirResult}
    # log all directory names
    @{files}=    dir names
    Log    ${files}
    # log default irectory path after connecting
    ${pwdMsg}=    pwd
    # Verify directory name is exist and corrected name
    Should Contain    ${files}    aspnet_client
    Should Contain    ${files}    PREFUND_DATA
    Should Contain    ${files}    PREFUND_SOURCE
    # Example of downloaded specific file 
    DOWNLOAD File       ${DIRECTORY}/DPSDA81_20110503_MXA.TXT       C:/Users/AtiwitK/Documents/DPSDA81_20110503_MXA.TXT
    FTP CLOSE
