*** Settings ***
Library     RequestsLibrary


*** Variables ***
${BASE_URL}     https://reqres.in/api
${x-api-key}    reqres-free-v1


*** Keywords ***
Call API Get User
    [Arguments]
    ...    ${page}
    ...    ${per_page}
    ${header}    Create Dictionary
    ...    accept=application/json
    ...    x-api-key=${x-api-key}
    ${params}    Create Dictionary
    ...    page=${page}
    ...    per_page=${per_page}
    Create Session    api    ${BASE_URL}    disable_warnings=1
    ${response}    GET On Session
    ...    alias=api
    ...    url=/users
    ...    headers=${header}
    ...    params=${params}
    ...    expected_status=any
    RETURN    ${response}
