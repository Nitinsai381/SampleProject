import { LightningElement } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import NAME_FIELD from "@salesforce/schema/Account.Name";
import PHONE_FIELD from "@salesforce/schema/Account.Phone";
import INDUSTRY_FIELD from "@salesforce/schema/Account.Industry";
import REVENUE_FIELD from "@salesforce/schema/Account.AnnualRevenue";
import ACCOUNT_NUMBER_FIELD from "@salesforce/schema/Account.AccountNumber";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class RecordsFormAccount extends LightningElement {
    industryValue;
    nameValue;
    phoneValue;
    revenueValue;
    accountNumberValue;
    showModal = true
    disableSave=false
    get options() {
        return [{ label: 'Agriculture', value: 'Agriculture' }, { label: 'Banking', value: 'Banking' }, { label: 'Biotechnology', value: 'Biotechnology' },{ label: 'Chemicals', value: 'Chemicals' },{ label: 'Technology', value: 'Technology' }];
    }
    handleInput(event) {
        if (event.target.name === 'name') {        
            this.nameValue = event.target.value
        }
        else if (event.target.name === 'phone') {          
            this.phoneValue = event.target.value
        }
        else if (event.target.name === 'AccountNumber') {
            this.accountNumberValue = event.target.value
        }
        else if (event.target.name === 'Industry') {
            this.industryValue=event.target.value
        }
        else if (event.target.name === 'AnnualRevenue') {
            this.revenueValue=event.target.value
        }
    }
    handleCreate() {
        const fields = {}
        fields[NAME_FIELD.fieldApiName] = this.nameValue
        fields[PHONE_FIELD.fieldApiName] = this.phoneValue
        fields[INDUSTRY_FIELD.fieldApiName] = this.industryValue
        fields[ACCOUNT_NUMBER_FIELD.fieldApiName] = this.accountNumberValue
        fields[REVENUE_FIELD.fieldApiName] = this.revenueValue
        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput).then(isSuccess => {
            const evt = new ShowToastEvent({
              title: "Account Created!",
              message: "Account created with Id : "+isSuccess.id,
              variant: 'success',
            });
            this.dispatchEvent(evt);
           this.showModal=false
        }).catch(error => {
            const evt = new ShowToastEvent({
                title: "Account Creation failed!",
                message: "Fill required fields",
                variant: 'error',
            });
            console.log('Error in creation == ',JSON.stringify(error))
            this.dispatchEvent(evt);
            this.disableSave=false
          })
    }
    handleCancel() {
        this.nameValue = null;
    }
    handleSave() {
        console.log('In Account save nameValue == ',this.nameValue)
        if (this.nameValue !== null || this.nameValue !== '') {
            
            this.handleCreate();
        }
this.disableSave=true
    }
    // handleCancel() {
    //     // this.nameValue = ''
    //     // this.accountNumberValue = ''
    //     // this.industryValue = ''
    //     // this.revenueValue = ''
    //     // this.phoneValue = ''
    //     this.template.querySelectorAll('lightning-input').forEach(element => {element.value=null})
    // }
    hideModalBox() {
        this.showModal = false
        console.log('showModal ==== ',this.showModal)
    }

}