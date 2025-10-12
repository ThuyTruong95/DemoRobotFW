*** Variables ***
${ADD_FIRSTNAME}            name=firstName
${ADD_MIDDLENAME}           name=middleName
${ADD_LASTNAME}             name=lastName
${ADD_EMPLOYEE_ID}          xpath=//label[normalize-space(.)='Employee Id']/ancestor::div[contains(@class,'oxd-input-group')]//input
${CHECKBOX_CREATE_LOGIN}    xpath=//label//span[contains(@class,'oxd-switch-input')]
${ADD_USERNAME}             xpath=//label[text()='Username']/../following-sibling::div/input
${ADD_PASSWORD}             xpath=//label[text()='Password']/../following-sibling::div/input
${ADD_CONFIRM_PASSWORD}     xpath=//label[text()='Confirm Password']/../following-sibling::div/input
${BTN_SAVE}                 xpath=//button[@type='submit']
${BTN_CANCEL}               xpath=//button[@type='button']
