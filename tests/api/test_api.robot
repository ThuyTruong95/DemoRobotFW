*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/api/reqres.robot


*** Variables ***
${BASE_URL}     https://reqres.in/api
${page}         2
${per_page}     ${EMPTY}


*** Test Cases ***
Get Users with param
    [Documentation]    Call API Get user có truyền param
    ${response}=                     Call API Get User    ${page}    ${per_page}
    ${status}=                       Set Variable    ${response.status_code}
    ${json_data}=                    Set Variable    ${response.json()}
    ${total}=                        Set Variable    ${json_data['total']}
    ${data}=                         Set Variable    ${json_data['data']}
    Log To Console    \nStatus: ${status}
    Should Be Equal As Integers     ${status}    200

Get Users use list variable
    ${response}    Call API Get User    ${page}    ${per_page}

    ${json_data}    Set Variable    ${response.json()}
    # --- SCALAR VARIABLE ---
    ${status}    Set Variable    ${response.status_code}
    Log    SCALAR EXAMPLE -- Status: ${status}
    Should Be Equal As Integers    ${status}    200

    # --- LIST VARIABLE ---
    ${data}    Set Variable    ${json_data['data']}
    @{emails}    Evaluate    [user['email'] for user in ${data}]
    Log Many    @{emails}

    # --- DICTIONARY VARIABLE ---
    ${support}    Get From Dictionary    ${json_data}    support
    ${url}    Get From Dictionary    ${support}    url
    ${text}    Get From Dictionary    ${support}    text
    Log    Support URL: ${url}
    Log    Support Text: ${text}

Test api get user
    [Documentation]     Kiểm thử API lấy danh sách user
    Create Session      reqres    ${BASE_URL}
    # Gửi request
    ${headers}=         Create Dictionary    x-api-key=${x-api-key}
    ${response}=        GET On Session
    ...    alias=reqres
    ...    url=/users?page=2
    ...    headers=${headers}
    ...    expected_status=any
    # Kiểm tra status code
    Should Be Equal As Numbers    ${response.status_code}    200
    # Kiểm tra header
    ${header_rps}=      Set Variable    ${response.headers}
    ${content_type}=    Set Variable    ${header_rps['Content-Type']}
    Should Be Equal     ${content_type}    application/json; charset=utf-8
    # Kiểm tra dữ liệu JSON
    ${data}=          Set Variable    ${response.json()}
    Length Should Be    ${data['data']}    6
    Dictionary Should Contain Key    ${data['data'][0]}    email
    Should Contain    ${data['data'][0]['email']}    @reqres.in
    # Ghi log
    Log To Console    Email: ${data['data'][0]['email']}

Test POST Create User
    [Documentation]     Kiểm thử API tạo mới user
    Create Session      reqres    ${BASE_URL}

    # Tạo payload JSON
    ${payload}=         Create Dictionary    name=Thùy    job=QC

    # Gửi POST request
    ${headers}=         Create Dictionary    x-api-key=${x-api-key}
    ${response}=        POST On Session    reqres    /users    headers=${headers}    json=${payload}

    # Kiểm tra status trả về
    Should Be Equal As Numbers    ${response.status_code}    201

    # Kiểm tra nội dung JSON trả về
    ${data}=            Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${data}    id
    Should Be Equal     ${data['name']}    Thùy
    Should Contain      ${data['job']}    QC
    Should Contain      ${response.headers['Content-Type']}    application/json; charset=utf-8

    # Ghi log
    Log To Console      Created new user: ${data['id']}

Test update user by PUT method
    [Documentation]                 Kiểm thử API cập nhật user
    Create Session                  api    ${BASE_URL}
    # Tạo request body, header
    ${body}=                        Create Dictionary    name=Test1    job=DEV
    ${headers}=                     Create Dictionary    x-api-key=${x-api-key}
    # Gửi PUT request
    ${resp}=                        PUT On Session    api    /api/users/1    headers=${headers}   json=${body}
    # Kiểm tra status code
    Should Be Equal As Numbers      ${resp.status_code}    200
    # Kiểm tra data trả về
    ${data}=                        Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${data}    updatedAt
    Should Be Equal                 ${data['name']}    Test1
    # Log data
    Log To Console                  Updated User: ${data}

Test api delete user
    [Documentation]    Kiểm thử xóa user bằng DELETE method
    Create Session    api    ${BASE_URL}
    # Tạo request body, header
    ${headers}=                     Create Dictionary    x-api-key=${x-api-key}
    # Gửi PUT request
    ${resp}=                        DELETE On Session    api    /api/users/1    headers=${headers}
    Should Be Equal As Numbers    ${resp.status_code}    204
    Should Be Empty    ${resp.content}
    Log To Console    User 1 deleted successfully

    # Kiểm tra user đã bị xóa
    ${getResp}=    GET On Session    api    /api/users/1
    Should Be Equal As Numbers    ${getResp.status_code}    404