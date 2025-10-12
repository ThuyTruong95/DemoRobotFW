*** Settings ***
Library     SeleniumLibrary


*** Test Cases ***
TC1:Login successed with valid account
    [Tags]    functional
    Open Browser    https://opensource-demo.orangehrmlive.com/    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//*[@name="username"]    timeout=10s
    Input Text    xpath=//*[@name="username"]    Admin
    Input Text    xpath=//*[@name="password"]    admin123
    Click Element    xpath=//button[@type="submit"]
    Sleep    2s
    Wait Until Page Contains Element    xpath=//p[@class="oxd-userdropdown-name"]
    Close Browser

TC2:Login failed with invalid account
    [Tags]    functional
    Open Browser    https://opensource-demo.orangehrmlive.com/    chrome
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//*[@name="username"]    timeout=10s
    Input Text    xpath=//*[@name="username"]    test
    Input Text    xpath=//*[@name="password"]    admin123
    Click Element    xpath=//button[@type="submit"]

#    Chờ thông báo lỗi hiển thị
    Wait Until Element Is Visible    xpath=//p[contains(@class,"oxd-alert-content-text")]    timeout=10s
##    Kiểm tra nội dung thông báo lỗi
    Element Text Should Be    xpath=//p[contains(@class,"oxd-alert-content-text")]    Invalid credentials
    Close Browser

TC3:Login failed with invalid account
    [Tags]    functional
    Open Browser    https://opensource-demo.orangehrmlive.com/    chrome
    Maximize Browser Window

    Wait Until Element Is Visible    xpath=//*[@name="username"]    timeout=10s
    Input Text    xpath=//*[@name="username"]    test
#    Input Text    xpath=//*[@name="password"]    admin123
    Click Element    xpath=//button[@type="submit"]

#    Chờ thông báo lỗi hiển thị
    Wait Until Element Is Visible
    ...    xpath=//label[text()='Password']/following::span[contains(@class,"oxd-input-field-error-message")]
    ...    timeout=10s
#    Kiểm tra nội dung lỗi
    Element Text Should Be
    ...    xpath=//label[text()='Password']/following::span[contains(@class,"oxd-input-field-error-message")]
    ...    Required
    Close Browser
