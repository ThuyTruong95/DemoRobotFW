*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${url}          https://testautomationpractice.blogspot.com/
${browser}      chrome

*** Keywords ***
Open browser and go to web page
# Mở trình duyệt và đi tới trang web
    Open Browser        ${url}      ${browser}
    Maximize Browser Window

*** Test Cases ***
Test web: Textbox & Text Area
    # Mở trình duyệt và đi tới trang web
    Open Browser                        ${url}      ${browser}
    Maximize Browser Window
    # Input giá trị vào textbox
    Input Text                          id=name         Nhập vào textbox Name
    Input Text                          xpath=//*[@id="email"]        test@gmail.com
    Input Text                          id=textarea     Nhập vào area Address \n Test 123

    # Clear text
    Clear Element Text                  xpath=//*[@id="email"]

    # Get giá trị ở ô input
    ${address}=                         Get Value      id=textarea
    Log To Console                      ${address}

    # Kiểm tra giá trị ở input với expect
    Textfield Value Should Be           id=name        Nhập vào textbox Name

Test web: Radio button & Checkbox
    Open browser and go to web page
    Sleep   2s
  # 1. Radio button
    # Kiểm tra radio button gender không select value nào
    Radio Button Should Not Be Selected    gender

    # Chọn radio button
    Select Radio Button                 gender          female

    # Kiểm tra radio button gender có select: female
    Radio Button Should Be Set To       gender          female

  # 2. Radio button
    # Kiểm tra checkbox đang không được select
    Checkbox Should Not Be Selected     id=monday
    # Chọn Checkbox
    Select Checkbox                     id=monday

    # Kiểm tra checkbox đang được select
    Checkbox Should Be Selected         id=monday




