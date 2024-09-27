*** Settings ***
Library     SeleniumLibrary
Library     Collections
Library     OperatingSystem
# Library     AutoItLibrary
Library     Process

*** Variables ***
${URL}          https://bahtnet-iwt.xtest-bot.or.th/EFSExternalWebUI/faces/home.jsp
# ${chrome_options}   add_argument("--user-data-dir=C:/Users/test/AppData/Local/Google/Chrome/User Data/Profile 1")
# ${PROFILE_PATH}   C:/Users/AtiwitK/AppData/Local/Microsoft/Edge/User Data/Default
# ${USER_DIR_PATH}   C:/Users/AtiwitK/AppData/Local/Microsoft/Edge/User Data/Profile 2
# ${EDGE_PATH}    C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe
# ${IE_DRIVER}    C:/Users/AtiwitK/Documents/IEDriverServer_Win32_4.14.0/IEDriverServer.exe
${credit_bic}               BOTHTHB1DDG
${EXPECTED_TEXT}            FI to FI Customer Credit Transfer (pacs.008)
${XPATH}                    //a[@id="downloadStaticRptInrForm:taskList:0:exPDFBtn"]
${timeout}                  30
${FALSE}                    False
${EXPECTED_FILE}            CF1202409260000.pdf
${DOWNLOADED_FILE_PATH}     C:/Users/AtiwitK/Downloads/${EXPECTED_FILE}
${DOWNLOAD_PATH}            C:/Users/AtiwitK/Downloads/

*** Test Cases ***
5.1.4 การใช้ Certificate ในการ Login
    [Documentation]    Test case to open Google Thailand in IE mode on Edge
    # Open IE mode on Edge
    # --- Step for disabled Protected mode to run IE  ---
    # 1. Change hexadicimal number = 3 for all zone
        # 1.1 Open Registry Editor
        # 1.2 Click Internet Settings --> Zones (0 - 4)
        # 1.3 select zone --> double click file name: 2500
        # 1.4 edit number = 3 base: Hexadicimal --> click ok
        # 1.5 repeat it from zone 0 to 4 **each zone is not having 2500**
    # 2. Change prompt certificate
        # 2.1 Open Internet Options
        # 2.2 Click Security --> Internet, Local Intranet, Trusted sites and Restricted sites
        # 2.3 Click Custom level.. --> Scroll and find 'Don't prompt for client certificate session when only one certifiicate exists'
        # 2.4 Click Enable --> ok
        # 2.5 repeat it from Internet, Local Intranet, Trusted sites and Restricted sites --> Apply --> ok

    Open Browser    ${URL}    ie  
    Maximize Browser Window 
    # Seacrh Credit BIC
    Click download file
    # Click download button

*** Keywords ***
Seacrh Credit BIC
    # Select menu dropdown
    Click Element                   id=main2
    Wait Until Element Is Visible   xpath=//span[contains(text(), 'Authorization')]
    Click Element                   xpath=//span[contains(text(), 'Authorization')]
    Wait Until Element Is Visible   xpath=//a[contains(text(), '${EXPECTED_TEXT}')]
    Click Element                   xpath=//a[contains(text(), '${EXPECTED_TEXT}')]
    # input BIC value, select dropdown and click search icon
    Set Selenium Timeout	        30 seconds
    Select Frame	                //iframe[@name="iframeDetail"]
    Wait Until Element Is Visible   xpath=//input[@id="mainForm:txtBiccode"]
    Input text                      xpath=//input[@id="mainForm:txtBiccode"]    ${credit_bic}
    Wait Until Element Is Visible   xpath=//td[contains(text(), '${credit_bic}')]
    Click Element                   xpath=//td[contains(text(), '${credit_bic}')]
    Wait Until Element Is Visible   xpath=//input[@name="mainForm:showModalCrebitBICCode"]
    Click Element                   xpath=//input[@name="mainForm:showModalCrebitBICCode"]
    # select BIC from pop up
    Wait Until Element Is Visible   xpath=//tbody[@id="sharePopupBicForm:bictbl:tb"]/..//a[contains(text(), '${credit_bic}')]
    Click Element                   xpath=//tbody[@id="sharePopupBicForm:bictbl:tb"]/..//a[contains(text(), '${credit_bic}')]
    # click search
    Wait Until Element Is Visible   xpath=//input[@name="mainForm:searchBtn"]
    Click Element                   xpath=//input[@name="mainForm:searchBtn"]
    Set Selenium Timeout	        10 seconds
    Close All Browsers

Click download file
    Click Element                       id=main2
    Wait Until Element Is Visible       xpath=//span[contains(text(), 'Report')]    
    Click Element                       xpath=//span[contains(text(), 'Report')]
    Wait Until Element Is Visible       xpath=//a[contains(text(), 'BAHTNET Report')]    
    Click Element                       xpath=//a[contains(text(), 'BAHTNET Report')]
    Set Selenium Timeout	            30 seconds
    Select Frame	                    //iframe[@name="iframeDetail"]
    Wait Until Element Is Visible       xpath=//img[@id="staticRptInrMenuForm:j_id_jsp_474309668_3:project:0::j_id_jsp_474309668_5:handle:img:collapsed"]
    Click Element                       xpath=//img[@id="staticRptInrMenuForm:j_id_jsp_474309668_3:project:0::j_id_jsp_474309668_5:handle:img:collapsed"]
    Set Selenium Timeout	            30 seconds
    Wait Until Element Is Visible       xpath=//a[contains(text(), 'หนังสือยืนยันรายการโอนเงินผ่านบาทเนต')]    
    Click Element                       xpath=//a[contains(text(), 'หนังสือยืนยันรายการโอนเงินผ่านบาทเนต')]
    # Set Selenium Timeout	            30 seconds
    Select Frame	                    //iframe[@name="iframeBrowseReport"]
    Wait Until Element Is Visible       ${XPATH}
    # Use AutoIt to handle the certificate pop-up
    ${result}=    Run Keyword And Return Status     Click Element       ${XPATH}
    IF      ${result} == ${FALSE}    
        Sleep    2s
        # AutoItLibrary.Run    "C:/Program Files (x86)/AutoIt3/SciTE/download5.exe"
        Run Process    C:/Program Files (x86)/AutoIt3/SciTE/download_bahtnet_file.exe
        Sleep    5s  # Wait for the download to complete
        # Verify downloading PDF file is exist
        File Should Exist    ${DOWNLOADED_FILE_PATH}
        # Verify PDF file is correct
        ${files}=    List Files in Directory    ${DOWNLOAD_PATH}
        ${file_name}=    Get From List    ${files}    0  # Assuming the downloaded file is the first in the list
        Should Be Equal As Strings    ${file_name}    ${EXPECTED_FILE}
        Set Selenium Timeout    30 seconds
    END
    # Remove File    ${file_path}
    Close All Browsers
