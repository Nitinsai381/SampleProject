import { LightningElement,wire,api } from 'lwc';
import accountContacts from '@salesforce/apex/AccountRelatedContacts.accountContacts';

export default class accountRelatedContacts extends LightningElement {
    @api recordId;
     contacts = [];
     displayContacts = [];
     error;
     notEmpty = false;
    contactsWithUrls = [];
    perSize = 5;
    start = 0;
    pageCount = 1;
    totalPages;
    
    
    
    @wire(accountContacts, { accId : '$recordId' })
    wiredData({ data, error }) {
        if (data) {
            console.log('recordId--', this.recordId);
            console.log('inside data coming');
            this.contacts = data;
            this.generateUrls();
            this.totalPages = Math.ceil(this.contacts.length / this.perSize);
            console.log('Total pages ______ ', this.totalPages);
            // this.notEmpty = this.contacts.length === 0 ? false : true;
            this.notEmpty = this.contacts.length > 0;
            // console.log('contacts----> ', this.contacts);
            this.updateDisplayContacts();
            console.log("Contacts available : ",this.notEmpty)
            console.log('contacts----> ', this.contactsWithUrls);
            // this.error = undefined;
        }
        
        else if (error) {
            this.error = error;
            this.contacts = [];
            this.notEmpty = false;
            console.log("Error in fetching data..")
        }
    }
    // totalPages = this.contacts.length;
    updateDisplayContacts() {
        this.displayContacts = this.contactsWithUrls.slice(this.start, this.start + this.perSize);
        console.log("data"+ this.contactsWithUrls);
        
    }
    // displayContacts =  this.contacts.slice(this.start, this.start + this.perSize);

    
    get isPreviousDisable() {
        // let isDisable = true;
        return (this.start === 0)
            
        //     isDisable = false;
        // }
        // return isDisable;
    }
    get isNextDisable() {
        return ((this.contacts.length - this.start) <= this.perSize)
    }
        
    // console.log("Contacts after slice",displayContacts);
    // contacts_url() {
    //     for (let i = 0; i < this.contacts.length; i++){
    //         // let contact = this.contacts[i];
    //         // let url = 'url';
    //         // this.contacts[i][url]="https://raagvitech76-dev-ed.develop.lightning.force.com/lightning/r/Contact/"+this.contacts[i].Id+"/view";
    //         // contact[url] = '/' + contact.Id + '/view';
    //         this.contacts[i].url = "https://raagvitech76-dev-ed.develop.lightning.force.com/lightning/r/Contact/" + this.contacts[i].Id + "/view";
    //     }
    // }
    generateUrls() {
        this.contactsWithUrls = this.contacts.map(contact => ({
            ...contact,
            url: `https://raagvitech76-dev-ed.develop.lightning.force.com/lightning/r/Contact/${contact.Id}/view`
        }));
    }
    
    onNext() {
        
        if (this.start + this.perSize < this.contactsWithUrls.length) {
            this.start += this.perSize;
            this.updateDisplayContacts();
            this.pageCount += 1
            console.log('Total pages ---- ',Math.floor(this.contactsWithUrls.length / this.perSize));
        } else {
            console.log("No more contacts to display.");
        }
    }
    onPrevious() {
        
        if (this.start - this.perSize >= 0) {
            this.start -= this.perSize;
            this.updateDisplayContacts();
            this.pageCount-=1
        } else {
            console.log("No previous contacts to display.");
        }
    }
    
}


