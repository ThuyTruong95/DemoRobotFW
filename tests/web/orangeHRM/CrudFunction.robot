*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/locators/menu.robot
Resource    ../../resources/locators/add_employee_page.robot
Resource    ../../resources/locators/employee_list_page.robot


*** Variables ***
${url}              https://opensource-demo.orangehrmlive.com/
${browser}          chrome
${username}         Admin
${password}         admin123
${firstname}        Nguyễn
${middlename}       Khánh
${lastname}         An123
${fullname}         ${firstname} ${middlename} ${lastname}


*** Test Cases ***
Verify Add Employee success
    [Tags]    functional
    # --- Login vào page OrangeHRM ---
    Login To OrangeHRM

    # --- Vào menu PIM > Add Employee ---
    Click Element    ${MENU_PIM}
    Wait Until Element Is Visible    ${ADD_EMP}    timeout=10s
    Click Element    ${ADD_EMP}

    # Nhập thông tin nhân viên cần thêm
    Wait Until Element Is Visible    ${ADD_FIRSTNAME}    timeout=10s
    Input Text    ${ADD_FIRSTNAME}    ${firstname}
    Input Text    ${ADD_MIDDLENAME}    ${middlename}
    Input Text    ${ADD_LASTNAME}    ${lastname}

    # Nhập thông tin login
    ${status}=    Get Element Attribute    xpath=//label//input[@type='checkbox']    checked
    IF    '${status}' != 'true'    Click Element    ${CHECKBOX_CREATE_LOGIN}
    Input Text    ${ADD_USERNAME}    test01
    Input Text    ${ADD_PASSWORD}    Test01@@
    Input Text    ${ADD_CONFIRM_PASSWORD}    Test01@@

    # --- Lấy giá trị trong field EmployeeID ---
    ${employee_id}=    Get Value    ${ADD_EMPLOYEE_ID}
    Log To Console    Employee ID là: ${employee_id}

    Click Button    ${BTN_SAVE}

    # --- Kiểm tra đã vào trang Personal Details ---
    Wait Until Page Contains Element    ${HDR_PERSONAL_DETAILS}    timeout=10s
    Page Should Contain    Personal Details

    # --- Vào page Employee List ---
    Click Element    ${EMP_LIST}

    # --- Tìm kiếm nhân viên mới ---
    Wait Until Element Is Visible    ${LIST_EMPLOYEE_ID_INPUT}    timeout=15s

    # --- Search theo employee Name ---
    Input Text    ${LIST_EMPLOYEE_NAME_INPUT}    ${fullname}
    Sleep    3s

    Click Button    ${LIST_BTN_SEARCH}

    # --- Kiểm tra kết quả có nhân viên mới ---
    Wait Until Element Is Visible    ${LIST_TABLE}    timeout=10s
    Sleep    5s
#    ${employee_id}=    Get Text    ${LIST_TABLE_ID_ROW1}    # Lấy giá trị ID ở dòng đầu tiên

    # Lấy all giá trị ID trong table
    ${all_ids}=    Get WebElements    ${LIST_TABLE_ALL_IDS}
    ${index}=    Set Variable    1
    FOR    ${id}    IN    @{all_ids}
        ${employee_id_result}=    Get Text    ${id}
        Log To Console    \nRow ${index}: id = ${employee_id_result}
        IF    $employee_id == $employee_id_result
            Log To Console    Found employee row ${index}
        END
        ${index}=    Evaluate    ${index} + 1
    END

    Close Browser


*** Keywords ***
Login To OrangeHRM
    [Tags]    functional
    Open Browser    ${url}    ${browser}    options=add_experimental_option("detach", True)
#    options=add_experimental_option("detach", True)    (Muốn giữ lại browser sau khi run test xong)
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//*[@name="username"]    timeout=10s
    Input Text    xpath=//*[@name="username"]    ${username}
    Input Text    xpath=//*[@name="password"]    ${password}
    Click Element    xpath=//button[@type="submit"]
    Sleep    2s
    Wait Until Page Contains Element    xpath=//p[@class="oxd-userdropdown-name"]
