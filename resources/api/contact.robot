*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}     https://thinking-tester-contact-list.herokuapp.com

*** Keywords ***
Call API login 1
    [Arguments]
    ...    ${email}
    ...    ${password}
    ${header}       Create Dictionary      Content-Type=application/json
    ${data}         Catenate
    ...     {
    ...     "email": "${email}",
    ...     "password": "${password}"
    ...     }
    ${data}         Evaluate    json.dumps(${data}, ensure_ascii=False).encode('utf-8')    json
    Create Session    api    ${BASE_URL}    disable_warnings=1

    ${response}    POST On Session
    ...    alias=api
    ...    url=/users/login
    ...    headers=${header}
    ...    data=${data}
    ...    expected_status=any
    RETURN    ${response}

Call API login
    [Arguments]
    ...    ${email}
    ...    ${password}
    &{headers}=    Create Dictionary    Content-Type=application/json
    &{body}=       Create Dictionary    email=${email}    password=${password}
    ${response}=   POST On Session
    ...     alias=contactApp
    ...     url=/users/login
    ...     headers=${headers}
    ...     json=${body}
    ...     expected_status=any
    RETURN    ${response}




