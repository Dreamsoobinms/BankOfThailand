*** Settings ***
Library           RequestsLibrary
Library           JSONLibrary

*** Variables ***
${URL}            https://apixgw2.bot.or.th/bot-iwt/partner-extranet/bnapi
${BODY}           {"inquiry_request": {"credit_bic": "BOTHTHB1DDG", "settlement_date": "2024-08-01"}}
${cert_path}      C:/Users/AtiwitK/Documents/Postman/DDG-2-cert.pem
${key_path}       C:/Users/AtiwitK/Documents/Postman/DDG-2-key.pem

*** Test Cases ***
5.1.3 Reguent แบบ มี Certificate ดึงข้อมูลได้ถูกต้อง
    #   # If you have certificate pfx file, have to install openssl from https://slproweb.com/products/Win32OpenSSL.html (Lite 3.2.3), set env and open cmd then follow the openssl cmd
    #       openssl pkcs12 -in C:\Users\AtiwitK\Documents\Postman\DDG-2.pfx -clcerts -nokeys -out C:\Users\AtiwitK\Documents\Postman\DDG-2-cert.pem -nodes
    #       openssl pkcs12 -in C:\Users\AtiwitK\Documents\Postman\DDG-2.pfx -nocerts -out C:\Users\AtiwitK\Documents\Postman\DDG-2-key.pem -nodes
    #   # Convert p12 file to pem file
    #       openssl pkcs12 -in "\\bot.or.th\cfs\FILESERV\QMDataFile\FIN1\SCB Cert\SCB-1.p12" -clcerts -nokeys -out "\\bot.or.th\cfs\FILESERV\QMDataFile\FIN1\SCB Cert\SCB-1-cert.pem" -nodes
    #       openssl pkcs12 -in "\\bot.or.th\cfs\FILESERV\QMDataFile\FIN1\SCB Cert\SCB-1.p12" -nocerts -out "\\bot.or.th\cfs\FILESERV\QMDataFile\FIN1\SCB Cert\SCB-1-key.pem" -nodes
    Send Post Request and Verify response body

*** Keywords ***
Send Post Request and Verify response body
    @{client certs}=  create list  ${cert_path}  ${key_path}
    ${HEADERS}=    Create Dictionary    accept=application/json    content-type=application/json    X-IBM-Client-Id=a7f05458-6cc3-45bd-b912-f974218d9277    X-IBM-Client-Secret=C8jN8tM4tU5rS5qK2nX4jR0dR5bG4cQ6aH5uF3rU5fK1sW0dN0
    Create Client Cert Session      my_session      url=${URL}      client_certs=${client certs}     headers=${HEADERS}     verify=True
    ${response}=    POST On Session    my_session    /inquiry-status-tracking    data=${BODY}   headers=${HEADERS}
    Log    ${response.status_code}
    Log    ${response.content}

    # Converting response content to json body
    ${response_json}=    evaluate    json.loads('''${response.content}''')    json
    # Create variable to store value in json body
    ${inquiry_response}         Set Variable   ${response_json['inquiry_response']}
    ${response_code}            Set Variable   ${inquiry_response}[response_code]
    ${reason}                   Set Variable   ${inquiry_response}[reason]
    ${settlement_datetime}      Set Variable   ${inquiry_response}[return_result][0][settlement_datetime]
    ${sender_ref_debit}         Set Variable   ${inquiry_response}[return_result][0][sender_ref_debit]
    ${message_type}             Set Variable   ${inquiry_response}[return_result][0][message_type]
    ${business_type}            Set Variable   ${inquiry_response}[return_result][0][business_type]
    ${debit_bic}                Set Variable   ${inquiry_response}[return_result][0][debit_bic]
    ${debit_account}            Set Variable   ${inquiry_response}[return_result][0][debit_account]
    ${credit_bic}               Set Variable   ${inquiry_response}[return_result][0][credit_bic]
    ${credit_account}           Set Variable   ${inquiry_response}[return_result][0][credit_account]
    ${debtor_account}           Set Variable   ${inquiry_response}[return_result][0][debtor_account]
    ${creditor_account}         Set Variable   ${inquiry_response}[return_result][0][creditor_account]
    ${settlement_amount}        Set Variable   ${inquiry_response}[return_result][0][settlement_amount]
    ${transaction_status}       Set Variable   ${inquiry_response}[return_result][0][transaction_status]
    ${error_code}               Set Variable   ${inquiry_response}[return_result][0][error_code]
    ${outgoing_incoming}        Set Variable   ${inquiry_response}[return_result][0][outgoing_incoming]

    # Verify in json body
    Should Be Equal As Strings    ${response_code}          S
    Should Be Equal As Strings    ${reason}                 Success
    Should Be Equal As Strings    ${settlement_datetime}    2024-08-02T09:33:16
    Should Be Equal As Strings    ${sender_ref_debit}       MXSE61327181
    Should Be Equal As Strings    ${message_type}           009
    Should Be Equal As Strings    ${business_type}          RGS
    Should Be Equal As Strings    ${debit_bic}              KASITHBK
    Should Be Equal As Strings    ${debit_account}          0010037969
    Should Be Equal As Strings    ${credit_bic}             BOTHTHB1DDG
    Should Be Equal As Strings    ${credit_account}         0010039627
    Should Be Equal As Strings    ${debtor_account}         0010037969
    Should Be Equal As Strings    ${creditor_account}       0010039627
    Should Be Equal As Strings    ${settlement_amount}      955214.41
    Should Be Equal As Strings    ${transaction_status}     E
    Should Be Equal As Strings    ${error_code}             MS716
    Should Be Equal As Strings    ${outgoing_incoming}      I


