*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${url}          https://opensource-demo.orangehrmlive.com/
${browser}      chrome
${username}     Admin
${password}     admin123
${firstname}    Nguyễn
${middlename}   Khánh
${lastname}     An

*** Keywords ***
Login To OrangeHRM
    [Tags]          Functional
    Open Browser    ${url}      ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//*[@name="username"]    timeout=10s
    Input Text          xpath=//*[@name="username"]   ${username}
    Input Text          xpath=//*[@name="password"]    ${password}
    Click Element       xpath=//button[@type="submit"]
    Sleep               2s
    Wait Until Page Contains Element    xpath=//p[@class="oxd-userdropdown-name"]
#    Close Browser


*** Test Cases ***
Verify Add Employee success
    [Tags]      Functional
    Login To OrangeHRM

    # Vào menu PIM > Add Employee
    Click Element    xpath=//span[text()='PIM']
    Wait Until Element Is Visible    xpath=//a[text()='Add Employee']    timeout=10s
    Click Element    xpath=//a[text()='Add Employee']

    # Nhập thông tin nhân viên cần thêm
    Wait Until Element Is Visible    name=firstName    timeout=10s
    Input Text    name=firstName     ${firstname}
    Input Text    name=middleName    ${middlename}
    Input Text    name=lastName      ${lastname}

    # Click Save
    Click Button    xpath=//button[@type='submit']

    # Kiểm tra đã vào trang Personal Details
    Wait Until Page Contains Element    xpath=//h6[text()='Personal Details']    timeout=10s
    Page Should Contain    Personal Details

