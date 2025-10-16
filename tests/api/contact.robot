*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../../resources/api/contact.robot

Suite Setup     Create Session    contactApp    https://thinking-tester-contact-list.herokuapp.com
Suite Teardown  Delete All Sessions

*** Variables ***
${EMAIL}        testapi01@fake.com12
${PASSWORD}     Testapi01@123

*** Test Cases ***
Login API - Success
    [Documentation]    Kiểm thử đăng nhập với thông tin hợp lệ
    &{headers}=    Create Dictionary    Content-Type=application/json
    &{body}=       Create Dictionary    email=${EMAIL}    password=${PASSWORD}
    ${response}=   POST On Session    contactApp    /users/login    headers=${headers}    json=${body}

    #  Kiểm tra HTTP status code
    Status Should Be    200    ${response}

    #  In kết quả ra console
    Log To Console    Status: ${response.status_code}
    Log To Console    Response: ${response.json()}

    #  Lấy token từ JSON response
    ${token}=    Get From Dictionary    ${response.json()}    token
    Log To Console    Token: ${token}

    #  Kiểm tra token không rỗng
    Should Not Be Empty    ${token}

    #  Kiểm tra email trong response
    ${user}=    Get From Dictionary    ${response.json()}    user
    ${email}=   Get From Dictionary    ${user}    email
    Should Be Equal As Strings    ${email}    ${EMAIL}

    #  Lưu token để dùng cho các test khác
    ${auth_header}=    Catenate    Bearer ${token}
    Set Suite Variable    ${AUTH_TOKEN}    ${auth_header}

Login API - Success 1
    [Documentation]    Kiểm thử đăng nhập với thông tin hợp lệ
    ${response}=     Call API login    ${EMAIL}    ${PASSWORD}

    #  Kiểm tra HTTP status code
    Status Should Be    200    ${response}

    #  In kết quả ra console
    Log To Console    Status: ${response.status_code}
    Log To Console    Response: ${response.json()}

    #  Lấy token từ JSON response
    ${token}=    Get From Dictionary    ${response.json()}    token
    Log To Console    Token: ${token}

    #  Kiểm tra token không rỗng
    Should Not Be Empty    ${token}

    #  Kiểm tra email trong response
    ${user}=    Get From Dictionary    ${response.json()}    user
    ${email}=   Get From Dictionary    ${user}    email
    Should Be Equal As Strings    ${email}    ${EMAIL}

    #  Lưu token để dùng cho các test khác
    ${auth_header}=    Catenate    Bearer ${token}
    Set Suite Variable    ${AUTH_TOKEN}    ${auth_header}
