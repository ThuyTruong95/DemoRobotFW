*** Settings ***
Library     SeleniumLibrary

*** Test Cases ***
Open web by input keywork
    [Tags]  function
    Open Browser    https://www.google.com      chrome
    Close Browser
