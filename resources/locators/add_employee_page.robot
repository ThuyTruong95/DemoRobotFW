*** Variables ***
${ADD_FIRSTNAME}        name=firstName
${ADD_MIDDLENAME}       name=middleName
${ADD_LASTNAME}         name=lastName
${ADD_EMPLOYEE_ID}      xpath=//label[normalize-space(.)='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input
${BTN_SAVE}             xpath=//button[@type='submit']
${BTN_CANCEL}           xpath=//button[@type='button']