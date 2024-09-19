*** Settings ***
Library    SSHLibrary

*** Variables ***
${HOST}    your_host
${USERNAME}    your_username
${PASSWORD}    your_password
${PORT}    22

*** Test Cases ***
Connect To Remote Server Using SFTP
    Open Connection    ${HOST}    port=${PORT}
    Login    ${USERNAME}    ${PASSWORD}
    # Add your SFTP commands here
    Close All Connections
