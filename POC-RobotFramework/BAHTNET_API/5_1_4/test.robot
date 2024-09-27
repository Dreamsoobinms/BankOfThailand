# *** Settings ***
# Library     AutoItLibrary
# Library     Browser

# *** Variables ***
# ${URL}          https://bahtnet-iwt.xtest-bot.or.th/EFSExternalWebUI/faces/home.jsp
# ${FALSE}        False

# *** Test Cases ***
# Handle Certificate Pop-Up
#     New Browser    edge     headless=false
#     Set Browser Timeout    30 seconds
#     # Use AutoIt to handle the certificate pop-up
#     ${result}=    Run Keyword And Return Status     New Page    ${URL}
#     IF      ${result} == ${FALSE}    
#         Sleep    2s
#         Run    "C:/Program Files (x86)/AutoIt3/SciTE/select_cert3.exe"
#         New Page    ${URL}
#         Set Browser Timeout    30 seconds
#     END
#     Sleep   10s
#     Close Browser