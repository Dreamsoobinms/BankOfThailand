*** Settings ***
Library           Browser
Library           Collections

*** Variables ***
${URL}            https://www.bot.or.th/th/statistics/exchange-rate.html
${YEAR}           2023
${MONTH}          12
${DAY}            21

*** Test Cases ***
5.1.1 การดึงข้อมูลตารางจาก Web ที่เป็นตาราง (in memory ,File)
    [Documentation]    Test case to extract table data from the web and format it
    New Browser    chromium     headless=True
    Set Browser Timeout    30 seconds
    New Page    ${URL}
    Accept Cookies
    Select Date    ${YEAR}    ${MONTH}    ${DAY}
    Get Exchange Rates From Website
    Close Browser

*** Keywords ***
Accept Cookies
    Browser.Click    xpath=//*[@id="container-b1d85c058c"]/div/div[3]/div/div[1]/div/div/table/tbody/tr[3]/td[3]/button/span[@class="necessary-cookie-button"]

Select Date
    [Arguments]    ${year}    ${month}    ${day}
    Browser.Fill Text    input[type="date"]    ${year}-${month}-${day}

Get Exchange Rates From Website
    ${dataTable}=    Create List
    ${header}=    Create List    ประเทศ    สกุลเงิน    อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน    อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน    อัตราขายถัวเฉลี่ย
    Append To List    ${dataTable}    ${header}
    ${rows}=    Get Elements    xpath=//table/tbody[@class="table_first_content"]/tr
    ${row_count}=    Get Length    ${rows}
    FOR    ${i}    IN RANGE    ${row_count}
        ${index}=   Evaluate    ${i} + 1
        ${country}=    Get Text    xpath=//table/tbody[@class="table_first_content"]/tr[${index}]/td/..//h3
        ${currency}=    Get Text    xpath=//table/tbody[@class="table_first_content"]/tr[${index}]/td/..//p
        ${buy_bill}=    Get Text    xpath=//table/tbody[@class="table_second_content"]/tr[${index}]/td[1]
        ${buy_transfer}=    Get Text    xpath=//table/tbody[@class="table_second_content"]/tr[${index}]/td[2]
        ${sell}=    Get Text    xpath=//table/tbody[@class="table_second_content"]/tr[${index}]/td[3]
        ${data_row}=    Create List    ${country}    ${currency}    ${buy_bill}    ${buy_transfer}    ${sell}
        Append To List    ${dataTable}    ${data_row}
    END
    Log    ${data_table}