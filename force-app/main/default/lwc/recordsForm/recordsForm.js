import { LightningElement } from 'lwc';

export default class RecordsForm extends LightningElement {
    objectValue;
    isAccountForm = false;
    isContactForm = false;
    isOpportunityForm = false;
    handleSelect(event) {
        this.objectValue = event.detail.value;
        console.log('Object value in recordForm ==== ', this.objectValue)
        this.isAccountForm = this.objectValue === 'Account'
        this.isContactForm = this.objectValue === 'Contact'
        this.isOpportunityForm=this.objectValue==='Opportunity'
    }
    
}