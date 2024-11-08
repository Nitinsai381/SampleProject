import { LightningElement } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";
import CONTACT_OBJECT from "@salesforce/schema/Contact";
import FIRST_NAME_FIELD from "@salesforce/schema/Contact.FirstName";
import LAST_NAME_FIELD from "@salesforce/schema/Contact.LastName";
import PHONE_FIELD from "@salesforce/schema/Contact.MobilePhone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Contact.AccountId"

import { ShowToastEvent } from "lightning/platformShowToastEvent";
export default class RecordsFormContact extends LightningElement {
    emailValue;
    firstNameValue;
    lastNameValue;
    mobileValue;
    accountIdValue;
    showModal = true
    disableSave=false
    // salutationsList = [
    //     { label: 'Mr.', value: 'Mr.' },
    //     { label: 'Ms.', value: 'Ms.' },
    //     { label: 'Mrs.', value: 'Mrs.' },
    //     { label: 'Dr.', value: 'Dr.' },
    //     { label: 'Prof.', value: 'Prof.' },
    // ];

    // get salutationOptions() {
    //     return this.salutationsList;
    // }
    handleSelectAccount(event) {
        this.accountIdValue = event.detail
        console.log('Selected account in contact == ',this.accountIdValue)
    }
    handleInput(event) {
        if (event.target.name === 'firstName') {        
            this.firstNameValue = event.target.value
            console.log('First Name == ',this.firstNameValue)
        }
        else if (event.target.name === 'lastName') {
            this.lastNameValue = event.target.value
            console.log('Last Name == ',this.lastNameValue)
        }
        else if (event.target.name === 'phone') {          
            this.mobileValue = event.target.value
            console.log('Mobile == ',this.mobileValue)
        }
        else if (event.target.name === 'email') {
            this.emailValue = event.target.value
            console.log('Email == ',this.emailValue )
        }

    }
    handleCreate() {
        
        const fields = {}
        fields[FIRST_NAME_FIELD.fieldApiName] = this.firstNameValue
        fields[LAST_NAME_FIELD.fieldApiName] = this.lastNameValue
        fields[PHONE_FIELD.fieldApiName] = this.mobileValue
        fields[EMAIL_FIELD.fieldApiName] = this.emailValue
        fields[ACCOUNT_ID_FIELD.fieldApiName] = this.accountIdValue
        // fields[REVENUE_FIELD.fieldApiName] = this.revenueValue
        const recordInput = { apiName: CONTACT_OBJECT.objectApiName, fields };
        createRecord(recordInput).then(isSuccess => {
            const evt = new ShowToastEvent({
              title: "Contact Created!",
              message: "Contact created with Id : "+isSuccess.id,
              variant: 'success',
            });
            this.dispatchEvent(evt);
           this.showModal=false
        }).catch(error => {
            const evt = new ShowToastEvent({
                title: "Contact Creation failed!",
                message: "Fill required fields",
                variant: 'error',
            });
            console.log('Error in creation == ',JSON.stringify(error))
            this.dispatchEvent(evt);
            this.disableSave=false
          })
    }
    handleCancel() {
        this.lastNameValue = null;
    }
    handleSave() {
        this.handleCreate();
        this.disableSave=true
    }

    hideModalBox() {
        this.showModal = false
        console.log('showModal ==== ',this.showModal)
    }

}