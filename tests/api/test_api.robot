*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../../resources/api/reqres.robot


*** Variables ***
${page}         2
${per_page}     ${EMPTY}


*** Test Cases ***
Get Users with param
    [Documentation]    Call API Get user có truyền param
    ${response}                     Call API Get User    ${page}    ${per_page}
    ${status}                       Set Variable    ${response.status_code}
    ${json_data}                    Set Variable    ${response.json()}
    ${total}                        Set Variable    ${json_data['total']}
    ${data}                         Set Variable    ${json_data['data']}
    Log To Console    \nStatus: ${status}
    Should Be Equal As Integers     ${status}    200

Get Users use list variable
    ${response}    Call API Get User    ${page}    ${per_page}

    ${json_data}    Set Variable    ${response.json()}
    # --- SCALAR VARIABLE ---
    ${status}    Set Variable    ${response.status_code}
    Log    SCALAR EXAMPLE -- Status: ${status}
    Should Be Equal As Integers    ${status}    200

    # --- LIST VARIABLE ---
    ${data}    Set Variable    ${json_data['data']}
    @{emails}    Evaluate    [user['email'] for user in ${data}]
    Log Many    @{emails}
#    @{emails}=    Create List
#    FOR    ${user}    IN    @{data}
#    ${email}    Set Variable    ${user['email']}
#    Append To List    ${emails}    ${email}
#    END
#    Log    LIST EXAMPLE -- Emails: ${emails}

    # --- DICTIONARY VARIABLE ---
    #    ${support}=    Set Variable    ${json_data['support']}
    ${support}    Get From Dictionary    ${json_data}    support
    ${url}    Get From Dictionary    ${support}    url
    ${text}    Get From Dictionary    ${support}    text
    Log    Support URL: ${url}
    Log    Support Text: ${text}
