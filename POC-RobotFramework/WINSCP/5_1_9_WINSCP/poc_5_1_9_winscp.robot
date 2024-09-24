*** Settings ***
Library    Process
Library    String
Library    Collections
Library    OperatingSystem

*** Variables ***
${WINSCP_PATH}      C:/Program Files (x86)/WinSCP/WinSCP.com
${SCRIPT_PATH}      C:/Users/AtiwitK/Documents/GitHub/BankOfThailand/POC-RobotFramework/WINSCP/5_1_9_WINSCP/winscp_script.txt
${DIR_PATH}         A81
${FILE_NAME}        DPSDA81_20220725_MXA.txt
${DOWNLOAD_PATH}    C:/Users/AtiwitK/Documents/GitHub/BankOfThailand/POC-RobotFramework/WINSCP/5_1_9_WINSCP/${DIR_PATH}/${FILE_NAME}

*** Test Cases ***
    # cmd: "C:/Program Files (x86)/WinSCP/WinSCP.com" /script=C:/Users/AtiwitK/Documents/GitHub/BankOfThailand/POC-RobotFramework/WINSCP/5_1_9_WINSCP/winscp_script.txt

5.1.9 ใช้ Robot Framework เชื่อมต่อ Session โดย WINSCP
    # Note the job\=<name> instead of job=name. There is no need to add multiple spaces between a command and its arguments.
    ${result}=   Run Process    cmd /c "${WINSCP_PATH}" /script\=${SCRIPT_PATH}      shell=True
    # log result output from runing cmd winscp command
    Log    ${result.stdout}
    Log    ${result.stderr}

    # Capture the directory listing from stdout
    ${dir_list}=    Set Variable    ${result.stdout}
    Log    ${dir_list}

    # Extract directory names
    ${lines}=    Split String    ${dir_list}    \n
    ${directories}=    Create List
    FOR    ${line}    IN    @{lines}
        ${parts}=    Split String    ${line}
        ${name}=    Get From List    ${parts}    -1
        Append To List    ${directories}    ${name}
    END

    # Log the extracted directory names
    Log    ${directories}

    # Verify the required directories are present
    Should Contain    ${dir_list}    aspnet_client
    Should Contain    ${dir_list}    PREFUND_DATA
    Should Contain    ${dir_list}    PREFUND_SOURCE

    # Verify the downloaded file exists
    File Should Exist    ${DOWNLOAD_PATH}

    # Verify the content of the downloaded file (optional)
    ${downloaded_content}=    Get File    ${DOWNLOAD_PATH}
    Log    ${downloaded_content}
    Should Contain    ${downloaded_content}    20220725;0010039503;100031.31
    Should Contain    ${downloaded_content}    20220725;0010039521;100032.32
    Should Contain    ${downloaded_content}    20220725;0010007369;100033.33