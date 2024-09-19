*** Settings ***
Library           Browser
Library           ExcelLibrary
Library           Collections
Library           BuiltIn

*** Variables ***
${URL}            https://www.bot.or.th/th/statistics/exchange-rate.html
${YEAR}           2023
${MONTH}          12
${DAY}            25
${EXCEL_FILE}     C:/Users/AtiwitK/Documents/GitHub/BankOfThailand/POC-RobotFramework/BOTWEBSITE/5_1_2/excel_file/ER_XLSX_25122023.xlsx
${SHEET_NAME}     ER_Sheet_1

*** Test Cases ***
5.1.2 การดึงข้อมูลจาก เพื่อเปรียบเทียบความถูกต้อง (Excel , Doc)
    [Documentation]    Test case to extract table data from the web and compare it with Excel data
    New Browser    chromium     headless=True
    Set Browser Timeout    30 seconds
    New Page    ${URL}
    Accept Cookies
    Select Date    ${YEAR}    ${MONTH}    ${DAY}
    ${web_data}=    Get Exchange Rates From Website
    Close Browser
    ${excel_data}=    Read Excel File
    Compare Data    ${web_data}    ${excel_data}

*** Keywords ***
Accept Cookies
    Browser.Click    xpath=//*[@id="container-b1d85c058c"]/div/div[3]/div/div[1]/div/div/table/tbody/tr[3]/td[3]/button/span[@class="necessary-cookie-button"]

Select Date
    [Arguments]    ${year}    ${month}    ${day}
    Browser.Fill Text    input[type="date"]    ${year}-${month}-${day}

Get Exchange Rates From Website
    # create datatable list and append with the column header
    ${dataTable}=    Create List
    ${header}=    Create List    ประเทศ    สกุลเงิน    อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน    อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน    อัตราขายถัวเฉลี่ย
    Append To List    ${dataTable}    ${header}
    # get row count of the table element from website
    ${rows}=    Get Elements    xpath=//table/tbody[@class="table_first_content"]/tr
    ${row_count}=    Get Length    ${rows}
    # loop get value from each row by index of column and append to datatable
    FOR    ${i}    IN RANGE    ${row_count}
        ${index}=   Evaluate    ${i} + 1
        ${country}=    Get Text    xpath=//table/tbody[@class="table_first_content"]/tr[${index}]/td/..//h3
        ${currency}=    Get Text    xpath=//table/tbody[@class="table_first_content"]/tr[${index}]/td/..//p
        ${buy_bill}=    Get Text    xpath=//table/tbody[@class="table_second_content"]/tr[${index}]/td[1]
        ${buy_transfer}=    Get Text    xpath=//table/tbody[@class="table_second_content"]/tr[${index}]/td[2]
        ${sell}=    Get Text    xpath=//table/tbody[@class="table_second_content"]/tr[${index}]/td[3]
        ${data_row}=    Create List    ${currency}   ${country}   ${buy_bill}   ${buy_transfer}   ${sell}
        Append To List    ${dataTable}    ${data_row}
    END
    Log    ${dataTable}
    RETURN    ${dataTable}

Read Excel File
    Open Excel Document    ${EXCEL_FILE}    doc_id=exchange_rates
    ${sheet_names}=    ExcelLibrary.Get List Sheet Names
    Log    Sheet names: ${sheet_names}
    ${getsheetreturn}    Get Sheet   ER_Sheet_1
    # create datatable list and append with the column header
    ${dataTable}=    Create List
    ${header}=    Create List    ประเทศ    สกุลเงิน    อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน    อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน    อัตราขายถัวเฉลี่ย
    Append To List    ${dataTable}    ${header}
    # get the row count in the excel for looping array datatable
    ${col_data}=    ExcelLibrary.Read Excel Column      col_num=1 
    ${row_num}=     BuiltIn.Evaluate        len(${col_data})
    # loop get value from each row by index of column in excel and append to datatable (row_index   column_index   excel_sheet)
    FOR    ${row}    IN RANGE    5    ${row_num}
        ${country}=    Read Excel Cell    ${row}    1   ${SHEET_NAME}
        ${currency}=    Read Excel Cell    ${row}    2      ${SHEET_NAME}
        ${buy_bill}=    Read Excel Cell    ${row}    3   ${SHEET_NAME}
        ${buy_transfer}=    Read Excel Cell    ${row}    4   ${SHEET_NAME}
        ${sell}=    Read Excel Cell    ${row}    5
        ${data_row}=    Create List    ${country}    ${currency}    ${buy_bill}    ${buy_transfer}    ${sell}
        Append To List    ${dataTable}    ${data_row}
    END
    Log    ${data_table}
    RETURN    ${dataTable}

Compare Data
    # compare datatable from website and excel file by each row
    [Arguments]    ${web_data}    ${excel_data}
    ${web_length}=    Get Length    ${web_data}
    ${excel_length}=    Get Length    ${excel_data}
    Should Be Equal As Numbers    ${web_length}    ${excel_length}
    FOR    ${i}    IN RANGE    ${web_length}
        ${web_row}=    Get From List    ${web_data}    ${i}
        ${excel_row}=    Get From List    ${excel_data}    ${i}
        Should Be Equal    ${web_row}    ${excel_row}
    END
