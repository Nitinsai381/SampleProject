import { LightningElement,wire,api } from 'lwc';
import accountContacts from '@salesforce/apex/AccountRelatedContacts.accountContacts';

export default class accountRelatedContacts extends LightningElement {
    @api recordId;
    contacts;
    error;
    notEmpty ;
    @wire(accountContacts, { accId : '$recordId' }) 
    wiredData({ data, error }) {
        if (data) {
            console.log('recordId--', this.recordId);
            console.log('inside data coming');
            this.contacts = data;
            this.notEmpty = this.contacts.length === 0 ? false : true;
            console.log("Contacts available : ",this.notEmpty)
            console.log('contacts----> ', this.contacts);
            // this.error = undefined;
        }
        
        else if (error) {
            console.log("Error in fetching data..")
        }
    }

    
}