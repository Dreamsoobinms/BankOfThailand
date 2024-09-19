*** Settings ***
Library           Browser

*** Variables ***
${URL}            https://www.botlc.or.th/
${FACEBOOK_URL}   https://www.facebook.com/BOTLearningCenter/
${EMAIL}          atiwit2011@hotmail.com
${PASSWORD}       dream6010742333

*** Test Cases ***
5.1.6 การเชื่อมต่อกับ Facebook
    [Documentation]    Test case to connect to Facebook and verify the play button
    New Browser    chromium     headless=False
    Set Browser Timeout    30 seconds
    New Page    ${URL}
    Accept Cookies
    Enter Website
    Verify and Click Facebook Icon    
    Verify Facebook Page
    Login To Facebook
    Verify Facebook Login

*** Keywords ***
Accept Cookies
    Browser.Click    text=ยอมรับ

Enter Website
    Browser.Click    role=link[name="เข้าสู่เว็บไซต์"]

Verify and Click Facebook Icon
    ${facebook_icon}=    Get Element    a:has(img[src="https://www.botlc.or.th/public/img/simple-icons/facebook.svg"])
    ${href}    Get Attribute    ${facebook_icon}   href
    Should Be Equal    ${href}    ${FACEBOOK_URL}
    Browser.Click    ${facebook_icon}
    Wait For Elements State    ${facebook_icon}    detached

Verify Facebook Page
    Wait For Condition    Url    should end with    ${FACEBOOK_URL}

Login To Facebook
    # input facebook email or phone number
    ${email_input}=    Get Element    role=textbox[name="Email address or phone number"]
    Wait For Elements State    ${email_input}    visible
    Browser.Fill Text    ${email_input}    ${EMAIL}
    # input facebook password
    ${password_input}=    Get Element    xpath=/html/body/div[1]/div/div[1]/div/div[5]/div/div/div[1]/div/div[2]/div/div/div/div[2]/form/div/div[4]/div/div/div/label/input
    Wait For Elements State    ${password_input}    visible
    Browser.Click    ${password_input}
    Browser.Fill Text    ${password_input}    ${PASSWORD}
    # click log in facebook
    ${login_button}=    Get Element    xpath=/html/body/div[1]/div/div[1]/div/div[5]/div/div/div[1]/div/div[2]/div/div/div/div[2]/form/div/div[5]/div/div/div[1]/div/span/span
    Wait For Elements State    ${login_button}    visible
    Browser.Click    ${login_button}

Verify Facebook Login
    Set Browser Timeout    30 seconds
    ${header}=    Get Element    h1
    Wait For Condition    Text    ${header}   contains    ศูนย์การเรียนรู้แบงก์ชาติ - BOTLC