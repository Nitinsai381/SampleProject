import { LightningElement,wire,api } from 'lwc';
// import accountContacts from '@salesforce/apex/AccountRelatedContacts.accountContacts';
import accountContacts from '@salesforce/apex/AccountRelatedContacts.dynamicAccountContacts';
import contactLabels from '@salesforce/apex/AccountRelatedContacts.contactLabels';

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
    metaDataRecords;
    
    
    @wire(accountContacts, { accId : '$recordId' })
    wiredData({ data, error }) {
        if (data) {
            console.log('recordId--', this.recordId);
            console.log('inside data coming');
            /**
             * [
             *  {colName : 'value}.,
             * 
             * 
             * contacts : [records];
             * ]
             * [
             *  {'Name' : 'value', 'Email' : value}
             *  {'Name' : 'value', 'Email' : value}
             *  {'Name' : 'value', 'Email' : value}
             *  {'Name' : 'value', 'Email' : value}
             *  {'Name' : 'value', 'Email' : value}
             *  {'Name' : 'value', 'Email' : value}
             * ]
             * [
             *  {colname : new map (name => value)}
             * ]
             */
            this.contacts = data;
            console.log('Contacts data ---- ', this.contacts);
            this.generateUrls();
            // this.makeEditable();
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

    // Custom metadata fetching 
    @wire(contactLabels)
    wireLabelData({ data, error }) {
        if (data) {
            this.metaDataRecords=data;
            console.log('MetaDataLabels----', this.metaDataRecords);   
        }
        else if (error) {
            console.log('Error in fetching labels for MetaData ---- ',error);
            
        }
      }
    

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
    get computedContacts() {
        return this.displayContacts.map(contact => {
            const contactValues = {};
            this.metaDataRecords.forEach(record => {
                contactValues[record.Column_Api_Name__c] = contact[record.Column_Api_Name__c];
            });
            return {
                ...contact,
                contactValues
            };
        });
    }
    getContactValue(contact, columnName) {
        return contact[columnName];
    }
    generateUrls() {
        this.contactsWithUrls = this.contacts.map(contact => ({
            ...contact,
            url: `https://raagvitech76-dev-ed.develop.lightning.force.com/lightning/r/Contact/${contact.Id}/view`,
            isEditable: false
            
        }));
        console.log('url ---- ', this.contactsWithUrls.url);
        console.log('isEditable ---- ', this.contactsWithUrls.isEditable);
    }
    // makeEditable() {
    //     this.contactsWithUrls = this.contactsWithUrls.map(contact => ({
    //         ...contact,
    //         isEditable: false
    //     }))
    // }
    onClickEdit(event) {
        // const currentId = event.target.dataSet.id;
        // this.contactsWithUrls = this.contactsWithUrls.map(contact => (
        //     contact.Id === currentId ? { ...contact, isEditing: true } : contact
        //         ))
        const contactId = event.target.dataset.id;
        console.log(contactId);
        this.contactsWithUrls = this.contactsWithUrls.map(contact => (
            contact.Id === contactId ? { ...contact, isEditable: true } : contact
        ));
        // this.generateUrls()
        console.log('Editable button is clicked ---- ', this.contactsWithUrls.isEditable);
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


