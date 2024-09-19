*** Settings ***
Library           Browser

*** Variables ***
${URL}              https://botdrm2-wb-d.bot.or.th/BOTDRM_Portal/Fileplan?classUri=37010
${title}            Test create folder
${owner}            adtestuser1
${note}             This is an Robot Framework test

*** Test Cases ***
5.1.7 การดึงข้อมูลตารางจาก Web ที่เป็นตาราง (in memory ,File)
    [Documentation]    Test case to extract table data from the web and format it
    New Browser    chromium     headless=True
    Set Browser Timeout    30 seconds
    New Page    ${URL}
    Click create folder
    Create Electronic Folder
    Close Browser

*** Keywords ***
Click create folder
    # Create Folder and Pop up
    Wait For Elements State     xpath=//*[@id="divBreadCrumb"]/nav/ol/li[4]/button                              visible
    Click                       xpath=//*[@id="divBreadCrumb"]/nav/ol/li[4]/button
    Wait For Elements State     xpath=//div[@class="dropdown-menu show"]/a/span[text()="Electronic Folder"]     visible
    Click                       xpath=//div[@class="dropdown-menu show"]/a/span[text()="Electronic Folder"]

Create Electronic Folder
    # Fill title
    ${title_textfield}=         Get Element                 xpath=//div[@class="modal-body"]/..//input[@id="Title"]
    Wait For Elements State     ${title_textfield}          visible
    Fill Text                   ${title_textfield}          ${title}
    # Select owner dropdown
    ${owner_dropdown}=          Get Element                 xpath=//div[@class="modal-body"]/..//span[@class="selection"]/span[@aria-labelledby="select2-OwnerLocationUri-container"]
    Wait For Elements State     ${owner_dropdown}           visible
    Click                       ${owner_dropdown}
    ${owner_search_field}=      Get Element                 xpath=//span[@class="select2-search select2-search--dropdown"]/input[@type="search"]
    Wait For Elements State     ${owner_search_field}       visible
    Fill Text                   ${owner_search_field}       ${owner}
    ${owner_list}=              Get Element                 xpath=//span[@class="select2-dropdown department-list-height select2-dropdown--below"]/..//span[@class="select2-results"]/..//li[contains(text(), '${owner}')]
    Wait For Elements State     ${owner_list}               visible
    Click                       ${owner_list}
    # Fill Note description
    ${Note_textbox}=            Get Element                 xpath=//div[@class="form-group row"]/..//input[@id="Notes"]
    Wait For Elements State     ${Note_textbox}             visible
    Fill Text                   ${Note_textbox}             ${note}
