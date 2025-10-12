*** Settings ***
Library     SeleniumLibrary

*** Test Cases ***
Login Validation
    [Template]    Try Login
    Admin    admin123
    admin    wrongpass

*** Keywords ***
Try Login
    [Arguments]    ${username}    ${password}
    TRY
        Open Browser    https://opensource-demo.orangehrmlive.com/    chrome
        Maximize Browser Window
        Wait Until Element Is Visible    xpath=//*[@name="username"]    timeout=10s
        Input Text    xpath=//*[@name="username"]    ${username}
        Input Text    xpath=//*[@name="password"]    ${password}
        Click Element    xpath=//button[@type="submit"]
        Wait Until Page Contains Element    xpath=//p[@class="oxd-userdropdown-name"]
    EXCEPT
        Log To Console    ❌ Đăng nhập thất bại với ${username}
    FINALLY
        Sleep    5s
        Close Browser
    END