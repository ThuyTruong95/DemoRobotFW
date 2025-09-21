*** Variables ***
${HDR_PERSONAL_DETAILS}         xpath=//h6[text()='Personal Details']
${LIST_EMPLOYEE_ID_INPUT}       xpath=//label[text()='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input
${LIST_EMPLOYEE_NAME_INPUT}     xpath=//label[text()='Employee Name']/ancestor::div[contains(@class,'oxd-input-group')]//input
${LIST_BTN_SEARCH}              xpath=//button[@type='submit' and contains(@class,'oxd-button--secondary')]
${LIST_TABLE}                   xpath=//div[@role='table']
${LIST_TABLE_BODY}              xpath=//div[@class='oxd-table-body']
${LIST_TABLE_ALL_IDS}           xpath=//div[@class='oxd-table-body']//div[@role='row']//div[@role='cell'][2]
${LIST_TABLE_ID_ROW1}           xpath=(//div[@class='oxd-table-body']//div[@role='row'][1]//div[@role='cell'])[2]

