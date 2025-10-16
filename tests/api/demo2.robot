*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/api/reqres.robot


*** Variables ***
${page}         2
${per_page}     ${EMPTY}


*** Test Cases ***