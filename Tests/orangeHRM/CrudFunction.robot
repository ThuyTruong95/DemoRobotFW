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
${fullname}     ${firstname} ${middlename} ${lastname}
${employee_id}     12345

*** Keywords ***
Login To OrangeHRM
    [Tags]          Functional
    Open Browser                        ${url}      ${browser}
    Maximize Browser Window
    Wait Until Element Is Visible       xpath=//*[@name="username"]    timeout=10s
    Input Text                          xpath=//*[@name="username"]   ${username}
    Input Text                          xpath=//*[@name="password"]    ${password}
    Click Element                       xpath=//button[@type="submit"]
    Sleep                               2s
    Wait Until Page Contains Element    xpath=//p[@class="oxd-userdropdown-name"]
#    Close Browser


*** Test Cases ***
Verify Add Employee success
    [Tags]      Functional
    #--- Login vào page OrangeHRM ---
    Login To OrangeHRM

    #--- Vào menu PIM > Add Employee ---
    Click Element                       xpath=//span[text()='PIM']
    Wait Until Element Is Visible       xpath=//a[text()='Add Employee']    timeout=10s
    Click Element                       xpath=//a[text()='Add Employee']

    # Nhập thông tin nhân viên cần thêm
    Wait Until Element Is Visible       name=firstName    timeout=10s
    Input Text                          name=firstName     ${firstname}
    Input Text                          name=middleName    ${middlename}
    Input Text                          name=lastName      ${lastname}
     # Nhập Employee Id
    Input Text    xpath=//label[text()='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input    ${employee_id}

    # Click Save
    Click Button                        xpath=//button[@type='submit']

    # --- Kiểm tra đã vào trang Personal Details ---
    Wait Until Page Contains Element    xpath=//h6[text()='Personal Details']    timeout=10s
    Page Should Contain                 Personal Details
     # Lưu Employee ID lại
#    Wait Until Element Is Visible    xpath=//label[text()='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input    timeout=20s
#    ${employee_id}=    Get Value    xpath=//label[text()='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input
#    Log    Employee ID: ${employee_id}
#    ${employee_id}=    Execute JavaScript    return document.evaluate("//label[text()='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.value;
    Log    Employee ID: ${employee_id}
    # --- Vào Employee List ---
    Click Element    xpath=//span[text()='PIM']
    Wait Until Element Is Visible    xpath=//a[text()='Employee List']    timeout=10s
    Click Element    xpath=//a[text()='Employee List']

    # --- Tìm kiếm nhân viên mới ---
    Wait Until Element Is Visible    xpath=//div[label[text()='Employee Id']]//input    timeout=15s
    Input Text    xpath=//div[label[text()='Employee Id']]//input    ${employee_id}
    Sleep    1s    # Đợi dropdown xuất hiện (auto-complete)

    Click Button    xpath=//button[@type='submit' and contains(@class,'oxd-button--secondary')]

    # --- Kiểm tra kết quả có nhân viên mới ---
    Wait Until Element Is Visible    xpath=//div[@role='table']    timeout=10s
    Page Should Contain Element      xpath=//div[@role='table']//div[text()='${FULLNAME}']
    Close Browser

