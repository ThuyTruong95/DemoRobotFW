*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${url}          https://www.google.com/
${browser}      chrome


*** Test Cases ***
TC1
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Input Text    xpath=//*[@id="APjFqb"]    facebook
    Press Keys    xpath=//*[@id="APjFqb"]    RETURN
#    Click Element    xpath=/html/body/div[2]/div[4]/form/div[1]
#    Click Element    xpath=/html/body/div[2]/div[4]/form/div[1]/div[1]/div[3]/center/input[1]
    Sleep    20s
