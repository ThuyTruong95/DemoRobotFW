*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${url}          https://testautomationpractice.blogspot.com/
${url1}         https://demo.automationtesting.in/Frames.html
${browser}      chrome
#${file_path}    ../../data/upload_file1.txt


*** Test Cases ***
Switch Between Windows (New Tab)
    [Documentation]    Click nút "New Tab", chuyển sang tab mới, đóng rồi quay lại tab chính.
    Open browser and go to page    ${url}    ${browser}

    # Click mở tab mới
    Click Button            xpath=//button[text()='New Tab']
    Sleep    2s
    # Get các window
    ${handles}=             Get Window Handles
    Log To Console          ${handles}

    # Switch sang cửa sổ mới
    Switch Window           ${handles}[1]
    Sleep    2s

    # Đóng cửa sổ hiện tại
    Close Window
    Sleep    5s

    # Quay lại tab đầu tiên
    Switch Window           ${handles}[0]
    Close Browser

Handle Popup Window Example
    [Documentation]    Click nút "Popup Windows", chuyển sang popup, rồi đóng popup.
    Open browser and go to page    ${url}    ${browser}

    # Click vào nút Popup Windows
    Click Button    xpath=//button[text()='Popup Windows']
    Sleep    2s

    ${handles}=    Get Window Handles
    Log To Console    ${handles}

    # Chuyển sang popup
    Switch Window    ${handles}[1]
    Sleep    2s
    Log To Console    Đang ở popup window

    # Đóng popup
    Close Window

    # Quay lại window chính
    Switch Window    ${handles}[0]
    Log To Console    Quay lại window chính
    Close Browser

Handle Single Iframe Example
    [Documentation]    Thực hành chuyển qua iframe đơn và nhập text.
    Open browser and go to page    ${url1}    ${browser}
    Sleep    2s

    # Chọn vào iframe (iframe có id="singleframe")
#    Select Frame    xpath=//iframe[@id='singleframe']
    Select Frame        id=singleframe
    Log To Console      Đã vào iframe đơn

    # Nhập text vào ô trong iframe
    Input Text          xpath=//input[@type='text']    Thực hành iframe trong robot framework

    # Quay lại trang chính
    Unselect Frame
    Log To Console    Quay lại main page

    Sleep    2s
    Close Browser

Handle Nested Iframe Example
    [Documentation]    Thực hành chuyển qua iframe lồng nhau và nhập text.
    Open browser and go to page    ${url1}    ${browser}
    Sleep    1s

    # Click vào tab "Iframe with in an Iframe"
    Click Element    xpath=//a[contains(text(),'Iframe with in an Iframe')]
    Sleep    2s

    # Vào iframe ngoài cùng
    Select Frame    xpath=//iframe[@src='MultipleFrames.html']
    Log To Console    Đã vào iframe ngoài

    # Vào iframe bên trong (nằm trong iframe ngoài)
    Select Frame    xpath=//iframe[@src='SingleFrame.html']
    Log To Console    Đã vào iframe bên trong

    # Nhập text vào input trong iframe trong cùng
    Input Text    xpath=//input[@type='text']    Thực hành với Nested iframe

    # Thoát ra từng lớp
    Unselect Frame    # Thoát khỏi iframe trong
    Unselect Frame    # Thoát khỏi iframe ngoài
    Log To Console    Đã quay lại main page

    Close Browser

Textbox & Text Area Example
    Open browser and go to page    ${url}    ${browser}
    # Input giá trị vào textbox
    Input Text    id=name    Test Name
    Input Text    xpath=//*[@id="email"]    test@gmail.com
    Input Text    id=textarea    Nhập vào area Address \n Test 123

    # Clear text
    Clear Element Text    xpath=//*[@id="email"]

    # Get giá trị ở ô input
    ${address}=    Get Value    id=textarea
    Log To Console    ${address}

    # Kiểm tra giá trị ở input với expect
    Textfield Value Should Be    id=name    Test Name

Checkbox Example
    Open browser and go to page    ${url}    ${browser}
    # Kiểm tra checkbox đang không được select
    Checkbox Should Not Be Selected    id=monday

    # Chọn Checkbox
    Select Checkbox    id=monday

    # Kiểm tra checkbox đang được select
    Checkbox Should Be Selected    id=monday
    Sleep    2s

    # Bỏ chọn checkbox
    Unselect Checkbox    id=monday
Radio button Example
    Open browser and go to page    ${url}    ${browser}
    # Kiểm tra radio button gender không select value nào
    Radio Button Should Not Be Selected    gender
    # Chọn radio button
    Select Radio Button    gender    female
    # Kiểm tra radio button gender có select: female
    Radio Button Should Be Set To    gender    female

Dropdown Example
    Open browser and go to page    ${url}    ${browser}
    Sleep    2s

    # List ra các giá trị trong dropdown list
    ${list_country}=    Get List Items    id=country
    Log To Console    ${list_country}

    # Lấy giá trị đang được chọn
#    List Selection Should Be    id=country
    ${selected}=    Get Selected List Label    id=country
    Log To Console    Label selected: ${selected}
    ${selected}=    Get Selected List Value    id=country
    Log To Console    Value selected: ${selected}

    # Select 1 giá trị trong dropdown list
    Select From List By Label    id=country    Canada
    Sleep    2s
    Select From List By Value    id=country    germany
    Sleep    2s
    Select From List By Index    id=country    5

Static Table Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View        xpath=//table[@name='BookTable']
    # Chờ bảng hiển thị
    Wait Until Element Is Visible   xpath=//table[@name='BookTable']    10s
    # C1: Sử dụng Get Element Count
#    ${rows}=    Get Element Count    xpath=//table[@name='BookTable']/tbody/tr
#    ${cols}=    Get Element Count    xpath=//table[@name='BookTable']/tbody/tr[1]/th

    # C1: Sử dụng Get WebElements
    ${rows}=                        Get WebElements     xpath=//table[@name="BookTable"]/tbody/tr[position()>1]
    ${cols}=                        Get WebElements     xpath=//table[@name="BookTable"]/tbody/tr[2]/td
    ${row_count}=                   Get Length    ${rows}
    ${col_count}=                   Get Length    ${cols}
    Log To Console    Số hàng: ${row_count}, số cột: ${col_count}

    # Duyệt từng dòng
    FOR    ${i}    IN RANGE    2    ${row_count + 2}
        ${book}=                    Get Text    xpath=//table[@name='BookTable']/tbody/tr[${i}]/td[1]
        ${author}=                  Get Text    xpath=//table[@name='BookTable']/tbody/tr[${i}]/td[2]
        ${subject}=                 Get Text    xpath=//table[@name='BookTable']/tbody/tr[${i}]/td[3]
        ${price}=                   Get Text    xpath=//table[@name='BookTable']/tbody/tr[${i}]/td[4]
        Log To Console          Row ${i} --- BookName: ${book} | Author: ${author} | Subject: ${subject} | Price: ${price}
    END

    Close Browser

Dynamic Table Example
    Open browser and go to page    ${url}    ${browser}
    Scroll Element Into View    xpath=//table[@id="taskTable"]
    # --- Lấy danh sách header ---
    ${headers}=    Get WebElements    xpath=//table[@id="taskTable"]/thead/tr/th
    ${header_count}=    Get Length    ${headers}

    # --- Đếm số hàng dữ liệu ---
    ${rows}=    Get Element Count    xpath=//table[@id="taskTable"]/tbody/tr

    Log To Console    Số hàng: ${rows} - Số cột: ${header_count}
    FOR    ${i}    IN RANGE    1    ${rows}+1
        ${line}=    Set Variable    Row ${i} ---
        FOR    ${j}    IN RANGE    1    ${header_count}+1
            ${header}=    Get Text    xpath=//table[@id="taskTable"]/thead/tr/th[${j}]
            ${value}=     Get Text    xpath=//table[@id="taskTable"]/tbody/tr[${i}]/td[${j}]
            ${line}=      Set Variable    ${line} ${header}: ${value} |
        END
        Log To Console    ${line}
    END

Simple Alert Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View        xpath=//button[text()="Simple Alert"]
    Click Element                   xpath=//button[text()="Simple Alert"]

    ${msg}=                         Set Variable    I am an alert box!
    # Kiểm tra alert, action=ACCEPT
    Alert Should Be Present         ${msg}      action=LEAVE
    Handle Alert                    ACCEPT
    Sleep    2s

Confirm Alert Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View        xpath=//button[text()="Confirmation Alert"]
    Click Element                   xpath=//button[text()="Confirmation Alert"]

    ${msg}=                         Set Variable    Press a button!
    # Kiểm tra alert, action=ACCEPT
    Alert Should Be Present         ${msg}      action=LEAVE
    Sleep    2s
    Handle Alert                    DISMISS
    Sleep    2s
    Scroll Element Into View        id=demo
    Element Text Should Be          id=demo    You pressed Cancel!

Prompt Alert Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View        id=promptBtn
    Click Element                   id=promptBtn

    ${msg}=                         Set Variable    Please enter your name:
    ${input}=                       Set Variable    Thùy
    # Kiểm tra alert, action=ACCEPT
    Alert Should Be Present         ${msg}      action=LEAVE
    Sleep    2s
    Input Text Into Alert           ${input}    action=LEAVE
    Sleep    5s
    Handle Alert                    ACCEPT
    Scroll Element Into View        id=demo
    Element Text Should Be          id=demo    Hello ${input}! How are you today?

Mouse Hover Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View    xpath=//h2[text()='Double Click']
    Mouse Over                  xpath=//button[text()='Point Me']
    # --- Chờ menu con hiển thị ---
    Wait Until Element Is Visible    xpath=//a[text()='Mobiles']    timeout=5s
    # --- Click vào menu con "Mobiles" ---
    Click Element    xpath=//a[text()='Mobiles']
    Sleep    2s
    Close Browser

Double Click & Drag And Drop Example
    Open browser and go to page     ${url}    ${browser}
    # Double Click Example
    Scroll Element Into View    xpath=//h2[text()='Drag and Drop']
    # Nhấp đúp chuột vào nút Copy Text
    Double Click Element        xpath=//button[text()='Copy Text']
    Sleep    3s
    # Kiểm tra text đã được copy qua textbox 2
    ${value}=    Get Value    id=field2
    Log To Console    Text sau khi double click: ${value}

    # Drag and Drop Example
    Scroll Element Into View    id=draggable
    Drag And Drop    id=draggable    id=droppable
     # Kiểm tra text trong box đích
    Element Text Should Be    id=droppable    Dropped!

Upload File Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View        xpath=//button[text()='Upload Multiple Files']
    # --- Chọn file ---
    Log To Console    ${EXECDIR}
    ${file1}    Set Variable    ${EXECDIR}/data/upload_file1.txt
    ${file2}    Set Variable    ${EXECDIR}/data/upload_file2.txt
    Choose File     id=singleFileInput    ${file1}

    # --- Click nút Upload
    Click Button    xpath=//form[@id='singleFileForm']//button
    ${status_text}=    Get Text    id=singleFileStatus
    Log To Console     Text upload file: ${status_text}

    # --- Chọn multi file ---
    Choose File    id=multipleFilesInput    ${file1}\n${file2}
    # --- Click nút Upload ---
    Click Button    xpath=//form[@id="multipleFilesForm"]//button

    # --- Đợi text hiển thị ---
    Wait Until Element Contains    id=multipleFilesStatus    Multiple files selected:    5s
    # --- Lấy nội dung kết quả ---
    ${status_text}=    Get Text    id=multipleFilesStatus
    Log To Console     Upload result:\n${status_text}
    # --- Kiểm tra tên file có trong kết quả ---
    Should Contain    ${status_text}    upload_file1.txt
    Should Contain    ${status_text}    upload_file2.txt

Date Picker Example
    Open browser and go to page     ${url}    ${browser}
    Scroll Element Into View        id=datepicker
    Click Element   id=datepicker
    Sleep       2s
    Click Element       xpath=//a[text()='20']

*** Keywords ***
Open browser and go to page
    [Arguments]     ${url}  ${browser}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
