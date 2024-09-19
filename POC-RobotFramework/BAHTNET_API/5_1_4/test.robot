*** Settings ***
Library    SeleniumLibrary
Library     Collections

*** Variables ***
${URL}          https://bahtnet-iwt.xtest-bot.or.th/EFSExternalWebUI/faces/home.jsp
${chrome_options}   add_argument("--user-data-dir=C:/Users/test/AppData/Local/Google/Chrome/User Data/Profile 1")
${PROFILE_PATH}   C:/Users/AtiwitK/AppData/Local/Microsoft/Edge/User Data/Default
${USER_DIR_PATH}   C:/Users/AtiwitK/AppData/Local/Microsoft/Edge/User Data/Profile 2
${EDGE_PATH}    C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe
${IE_DRIVER}    C:/Users/AtiwitK/Documents/IEDriverServer_Win32_4.14.0/IEDriverServer.exe
${IE_OPTIONS}    Evaluate    sys.modules['msedge.selenium_tools'].EdgeOptions()    sys, msedge.selenium_tools
${BROWSER}    edge
${EDGE_OPTIONS}    Evaluate    sys.modules['selenium.webdriver.edge.options'].Options()    sys, selenium.webdriver.edge.options

*** Test Cases ***
Handle Certificate Pop-Up
    # ${options}=  Evaluate  sys.modules['selenium.webdriver'].EdgeOptions()  sys, selenium.webdriver
    # Call Method    ${options}   add_argument  --ie-mode
    # Call Method    ${options}   add_argument  --edge-executable-path\=${EDGE_PATH}
    # Call Method    ${options}   add_argument  --ie-driver-path\=${IE_DRIVER}
    # Call Method    ${options}   add_argument  --user-data-dir\=${USER_DIR_PATH}
    # Call Method    ${options}   add_argument  --profile-directory\=Default
    # Create WebDriver   Edge   options=${options}
    # ${options}=  Evaluate  Options()  selenium.webdriver.edge.options
    # CCall Method    ${options}   add_argumentn    debuggerAddress    localhost:0
    # Create WebDriver    edge    options=${options}
    Open Browser    ${URL}    edge    options=add_argument("--remote-debugging-port=0")   
    # Go To   ${URL}
    # Sleep   5000s
    # Open Browser    ${URL}    internetexplorer
    # Maximize Browser Window
    # Sleep    5s
    # ${service}=    Evaluate    sys.modules['selenium.webdriver.ie.service'].Service("${IE_DRIVER}")    sys, selenium.webdriver
    # Open Browser    ${URL}    ie    service=${service}
    # Maximize Browser Window
    # Sleep    5s
    # [Teardown]    Close Browser
    # # Open Browser    about:blank    	internetexplorer
    # # Go To   ${URL}
    # Set Selenium Timeout    30 seconds
    # # ${result}=    Run Keyword And Return Status    Go To    ${URL} 
    # # Run Keyword If    '${result}' == 'True'    
    # #     Sleep    2s
    # #     Run Process    C:/Program Files (x86)/AutoIt3/SciTE/select_cert3.exe
    # #     Go To    ${URL}
    # #     Set Selenium Timeout    30 seconds
    # # Sleep    10s
    # Close Browser

# Verify Facebook Page
#     Wait Until Location Contains    ${URL}
#     Wait Until Network Is Idle    timeout=10s

    # [Documentation]  Open Microsoft Edge in IE mode using IEDriver
    # ${options}=  Evaluate  sys.modules['selenium.webdriver.ie.options'].Options()  sys, selenium.webdriver
    # Call Method  ${options}  add_additional_option  "ie.edgechromium"  True
    # Call Method  ${options}  add_additional_option  "ie.edgepath"  "${EDGE_PATH}"
    # ${capabilities}=  Evaluate  sys.modules['selenium.webdriver.common.desired_capabilities'].DesiredCapabilities.INTERNETEXPLORER.copy()  sys, selenium.webdriver
    # Set To Dictionary  ${capabilities}  ignoreProtectedModeSettings  True
    # Open Browser    ${URL}      ie      executable_path=${IE_DRIVER}  options=${options}  desired_capabilities=${capabilities}
    # Close All Browsers

    # ${options}=  Evaluate  Options()  selenium.webdriver.edge.options
    # Call Method  ${options}  use_chromium  True
    # Call Method  ${options}  binary_location  "${EDGE_PATH}"
    # Open Browser  ${URL}  edge  options=${options}
    # Close All Browsers