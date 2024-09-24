*** Settings ***
Library    OperatingSystem
Library    SSHLibrary
Library    Collections

*** Variables ***
${HOST}         efswin-ap1-t1
${PORT}         2121
${USERNAME}     botefscauser
${PASSWORD}     botefscauser
${REMOTE_PATH}    /PREFUND_DATA/

*** Test Cases ***
Connect To SFTP Server
    [Documentation]    Connect to the SFTP server and list files
    Open Connection    ${HOST}    port=${PORT}
    ${output}=   Login    ${USERNAME}    ${PASSWORD}
    Should Contain	    ${output}	Last login at	
    ${files}=    List Files In Directory    ${REMOTE_PATH}
    Log    ${files}
    Close Connection

# Download File From SFTP Server
#     [Documentation]    Download a file from the SFTP server
#     Open Connection    ${HOST}    port=${PORT}
#     Login    ${USERNAME}    ${PASSWORD}
#     Get File    ${REMOTE_PATH}/file.txt    ${LOCAL_PATH}/file.txt
#     Close Connection

# Upload File To SFTP Server
#     [Documentation]    Upload a file to the SFTP server
#     Open Connection    ${HOST}    port=${PORT}
#     Login    ${USERNAME}    ${PASSWORD}
#     Put File    ${LOCAL_PATH}/file.txt    ${REMOTE_PATH}/file.txt
#     Close Connection
