*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary

*** Variables ***
${BASE_URL}         https://apigw1.bot.or.th/bot-iwt/partner-nc/Stat-ExternalInterestRate/v2/EXT_INT_RATE
${START_PERIOD}     2024-08-09
${END_PERIOD}       2024-08-09
${CLIENT_ID}        fd1cbc21-729c-426c-9a25-7421cc525297
${CLIENT_SECRET}    E4cU1aE0tK7uC4pY5vQ1jY0sP2sV4lU5yI1pU4mF0aS4yV8hV3

*** Test Cases ***
5.1.3 Reguent แบบไม่มี Certificateสามารถเรียก API เพื่อดึงข้อมูลได้ถูกต้อง (มีการ Validate ในตัวด้วยว่า Return พร้อมการตรวจสอบด้วย)
    ${headers}=    Create Dictionary    X-IBM-Client-Id=${CLIENT_ID}    X-IBM-Client-Secret=${CLIENT_SECRET}      accept=application/json
    Create Session    my_session    ${BASE_URL}     headers=${headers}     verify=True
    ${params}=    Create Dictionary    start_period=${START_PERIOD}    end_period=${END_PERIOD}
    ${response}=    Get On Session    my_session    /    headers=${headers}    params=${params}
    # verify response status and content
    Should Be Equal As Strings    ${response.status_code}    200
    Log    ${response.content}
    # the response content is interpreted as UTF-8 (handle thai alphabets)
    ${response.encoding}=    Set Variable    utf-8
    Log    ${response.content.decode('utf-8')}
    ${response_json}=    evaluate    json.loads('''${response.content.decode('utf-8')}''')    json
    Log    ${response_json}
    ${result}         Set Variable   ${response_json['result']}
    # Create variable to store value in json body (Example)
    ${timestamp}                Set Variable   ${result}[timestamp]
    ${api}                      Set Variable   ${result}[api]
    # data_header value
    ${report_name_eng}          Set Variable   ${result}[data][data_header][report_name_eng]
    ${report_name_th}           Set Variable   ${result}[data][data_header][report_name_th]
    ${report_uoq_name_eng}      Set Variable   ${result}[data][data_header][report_uoq_name_eng]
    ${report_uoq_name_th}       Set Variable   ${result}[data][data_header][report_uoq_name_th]
    # report_source_of_data value
    ${source_of_data_eng}       Set Variable   ${result}[data][data_header][report_source_of_data][0][source_of_data_eng]
    ${source_of_data_th}        Set Variable   ${result}[data][data_header][report_source_of_data][0][source_of_data_th]

    # Verify in json body
    Should Contain Any            ${timestamp}              2024-09-19
    Should Be Equal As Strings    ${api}                    External Interest Rates (Percent per annum)
    Should Be Equal As Strings    ${report_name_eng}        External Interest Rates
    Should Be Equal As Strings    ${report_name_th}         อัตราดอกเบี้ยต่างประเทศ
    Should Be Equal As Strings    ${report_uoq_name_eng}    (Percent per annum)
    Should Be Equal As Strings    ${report_uoq_name_th}     (อัตราร้อยละต่อปี)
    Should Be Equal As Strings    ${source_of_data_eng}     Thomson Reuters (Refinitiv)
    Should Be Equal As Strings    ${source_of_data_th}      Thomson Reuters (Refinitiv)

