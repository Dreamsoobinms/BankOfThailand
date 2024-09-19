*** Settings ***
Library           Process
Library           JSONLibrary

*** Variables ***
${COLLECTION}     C:/Users/AtiwitK/Documents/Postman/[USER][3-IWT] NEW BAHTNET API TEST.postman_collection.json
${CERTIFICATE}    C:/Users/AtiwitK/Documents/Postman/DDG-2-cert.pem
${KEY}            C:/Users/AtiwitK/Documents/Postman/DDG-2-key.pem
${OUTPUT}         C:/Users/AtiwitK/Documents/Postman/output.json

*** Test Cases ***
5.1.8 Verify Run Newman with Postman collection using Robot Framework
    Run Postman Collection with Newman
    Load JSON from output file and get 'run' body value
    Get 'Executed' and 'Failed' status from 'iterations, requests, test-scripts, prerequest-scripts and assertions'
    Verification of 'Executed' status from 'iterations, requests, testScripts, prerequest_scripts and assertions'
    Verification of 'Passed' status from 'iterations, requests, testScripts, prerequest_scripts and assertions'
    Extract 'inquiry_request' and compare 'request_value' from 'DDG-ST1-INQUIRY' file

*** Keywords ***
    # process library cmd: pip install robotframework-process
    # newman installation cmd: $ npm install -g newman
    # newman cmd: newman run "C:\Users\AtiwitK\Documents\Postman\[USER][3-IWT] NEW BAHTNET API TEST.postman_collection.json" --ssl-client-cert "C:\Users\AtiwitK\Documents\Postman\DDG-2-cert.pem" --ssl-client-key "C:\Users\AtiwitK\Documents\Postman\DDG-2-key.pem" -r cli,json --reporter-json-export "C:\Users\AtiwitK\Documents\Postman\output.json"
Run Postman Collection with Newman
    [Documentation]    Run Postman collection using Newman with client certificate and key
    Log    Collection Path: ${COLLECTION}
    Log    Certificate Path: ${CERTIFICATE}
    Log    Key Path: ${KEY}
    Run Process    cmd /c newman run "${COLLECTION}" --ssl-client-cert "${CERTIFICATE}" --ssl-client-key "${KEY}" -r cli,json --reporter-json-export "${OUTPUT}"    shell=True

Load JSON from output file and get 'run' body value
    # load json from output file
    ${result}    Load JSON From File    ${OUTPUT}
    Log    result: ${result}
    Set Global Variable    ${result_body}    ${result}
    # get value body of 'run' from json body
    ${run}       Get Value From JSON    ${result}    run
    Log    run: ${run}
    Set Global Variable    ${stats}    ${run}

Get 'Executed' and 'Failed' status from 'iterations, requests, test-scripts, prerequest-scripts and assertions'
    ${status}    Create List    iterations    requests    testScripts    prerequestScripts    assertions
    FOR    ${status_key}    IN    @{status}
        # get value from JSON body by specific value
        ${executed}     Get Value From JSON    ${stats}    $..${status_key}.total
        ${failed}       Get Value From JSON    ${stats}    $..${status_key}.failed
        # convert json list to string
        ${executed_str}=        Convert To String       ${executed}[0]
        ${failed_str}=          Convert To String       ${failed}[0]
        # create grobal var
        Set Global Variable    ${${status_key}_executed_value}      ${executed_str}[0]
        Set Global Variable    ${${status_key}_failed_value}        ${failed_str}[0]
    END

Verification of 'Executed' status from 'iterations, requests, testScripts, prerequest_scripts and assertions'
    # verify run postman collection are all executed 
    Should Be Equal    ${iterations_executed_value}             1
    Should Be Equal    ${requests_executed_value}               3
    Should Be Equal    ${testScripts_executed_value}            3
    Should Be Equal    ${prerequestScripts_executed_value}      3
    Should Be Equal    ${assertions_executed_value}             0

Verification of 'Passed' status from 'iterations, requests, testScripts, prerequest_scripts and assertions'
    # verify run postman collection are all passed
    Should Be Equal    ${iterations_failed_value}               0
    Should Be Equal    ${requests_failed_value}                 0
    Should Be Equal    ${testScripts_failed_value}              0
    Should Be Equal    ${prerequestScripts_failed_value}        0
    Should Be Equal    ${assertions_failed_value}               0

Extract 'inquiry_request' and compare 'request_value' from 'DDG-ST1-INQUIRY' file
    # get inquiry_request of 'DDG-ST1-INQUIRY' from json output file
    ${body_list}=    Get Value From Json    ${result_body}    $.collection.item[0].request.body.raw
    # convert to string to remove \n 
    ${body}=    Convert To String    ${body_list[0]}
    # convert dtring to json formate type
    ${parsed_body}=    Evaluate    json.loads('''${body}''')    json
    # extract credit_bic & settlement_date value (convert json list to string)
    ${credit_bic}=    Get Value From Json    ${parsed_body}    $.inquiry_request.credit_bic
    ${credit_bic}=    Convert To String    ${credit_bic}[0]
    ${settlement_date}=    Get Value From Json    ${parsed_body}    $.inquiry_request.settlement_date
    ${settlement_date}=    Convert To String    ${settlement_date}[0]
    Log    Credit BIC: ${credit_bic}
    Log    Settlement Date: ${settlement_date}
    # compare 'request_value'
    Should Be Equal    ${credit_bic}        BOTHTHB1DDG
    Should Be Equal    ${settlement_date}    2021-04-28

