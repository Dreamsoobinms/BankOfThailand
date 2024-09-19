*** Settings ***
Library           Browser

*** Variables ***
${URL}                  https://www.botlc.or.th/
${youtube}                 //iframe[@title="YouTube video player"] >>> //button[class="ytp-large-play-button.ytp-button.ytp-large-play-button-red-bg"]

*** Test Cases ***
5.1.5 การเชื่อมต่อกับ YouTube
    [Documentation]    Test case to connect to YouTube and verify the play button
    New Browser    chromium     headless=True
    Set Browser Timeout    30 seconds
    New Page    ${URL}
    Accept Cookies
    Enter Website
    Verify YouTube Play Button
    Close Browser

*** Keywords ***
Accept Cookies
    Wait For Elements State    xpath=//a[@aria-label="allow cookies"]    visible
    Click    xpath=//a[@aria-label="allow cookies"]

Enter Website
    Wait For Elements State    xpath=//a[text()='เข้าสู่เว็บไซต์']    visible
    Click    xpath=//a[text()='เข้าสู่เว็บไซต์']
    # Wait For Elements State    text=หน้าแรก    visible

Verify YouTube Play Button    
    Sleep   5s
    Scroll By   ${NONE}     1800     0   smooth
    Sleep   5s
    # Select iframe for specified element
    ${iframe}   Get Element     xpath=//iframe[@title="YouTube video player"] 
    Wait For Elements State    ${iframe}    visible
    # Select element from body html in iframe
    ${youtube}      Get Element    ${iframe} >>> xpath=/html/body/div/div/div[4]/button
    Wait For Elements State    ${youtube}    visible
    # get value attribute from youtube button
    ${aria_label}=    Get Attribute    ${youtube}    aria-label
    ${title}=    Get Attribute    ${youtube}    title
    ${class}=    Get Attribute    ${youtube}    class
    # compare value
    Should Be Equal    ${aria_label}    Play
    Should Be Equal    ${title}    Play
    Should Be Equal    ${class}    ytp-large-play-button ytp-button ytp-large-play-button-red-bg
