import { LightningElement,wire,api } from 'lwc';
import accountContacts from '@salesforce/apex/AccountRelatedContacts.relatedContactsTable';

export default class accountRelatedContacts extends LightningElement {
    @api recordId;
    contacts={};
    // dynamicContacts={};
    labels=[];
    contactData = [];
    contactsArray = [];
    contactKeys=[];
    notEmpty = false;
    @wire(accountContacts, { accId: '$recordId' })
    wiredData({ data, error }){
        if (data) {
            console.log(data);
            console.log(typeof data);
            this.contacts = data;
            this.notEmpty = this.contacts.length > 0;
            console.log('Has contacts ===: ', this.notEmpty);
            console.log('this.contacts--', this.contacts);
            // this.contacts = data;
            console.log('Data available ---- ',JSON.parse( JSON.stringify(data)));
            // this.jsonformatData = JSON.stringify(this.contacts[0]);
        //    this.contacts.data.forEach(element => {
        //        this.labels.push(element.columnName);
            //    });
        //     for (let key in this.contacts) {
        //      if(key ==='data')  { for (let key2 in key) {
        //             if (key2 === 'columnName') {
                    
        //                 console.log('this is key----',key);
        //                 this.contactLabels.push(key.columnName);
        //             }
        //        }}
            //    }
            // this.updateDisplayContacts();
            this.labels = this.contacts.slice(0,data.length - 1);
            console.log('Data in labels after slice ---- ', JSON.stringify(this.labels));
            this.contactData = this.contacts.slice(this.contacts.length - 1, this.contacts.length);
            console.log('Data in contacts after slice ---- ', JSON.stringify(this.contactData));
            this.labels = this.labels.map(label => label.columnName);
            console.log('Data in labels ---- ', JSON.stringify(this.labels));

            this.contactKeys = this.labels.map(column =>column.replace(' ', '.') );
                
           
            console.log('Keys in contacts from labels ===== ',JSON.stringify(this.contactKeys))
            // this.contactKeys = Object.keys(this.contactKeys[0].contacts[0]);
            // console.log('Keys in contacts ===== ',JSON.stringify(this.contactKeys))
            // console.log('Data in contactData ---- ', JSON.stringify(this.contactData));
            // console.log('Contact object values',JSON.stringify( Object.values(this.contactData)))
            // this.dynamicContacts = {
               
            //     labels: this.labels,
            //     contacts: this.contactData
            // };
            // console.log('Data with labels and contacts ---- ', JSON.stringify(this.dynamicContacts));

            // for (let key in this.contactKeys) {
            //     if(key != null){
            //         for (let contact in this.contactData[0].contacts) {
            //         if(contact!=null){
            //         this.contactsArray.push(contact.map(con => {
            //            return (con[key] || null)
            //         }))}
            //     }
            // }
            // }
            // this.contactsArray = this.contactData[0].contacts.forEach(contact => {
            // this.contactsKeys.map(key => {
            //     return [contact[key]];
            // });
            // })
            
            this.contactsArray = this.contactData[0].contacts.map(contact => {
                return this.contactKeys.map(key => {
                    
                    return key.split('.').reduce((obj, prop) => obj && obj[prop], contact) || null;
                });
            });
            console.log('Contacts in ContactsArray ==== ', JSON.stringify(this.contactsArray));

          
        }
        else if (error) {
            this.error = error;
            this.contacts = [];
            this.notEmpty = false;
            console.log("Error in fetching data..")
        }
    }
    // updateDisplayContacts() {
    //     this.contacts = this.contacts.slice(this.start, this.start + this.perSize);
    //     console.log("data"+ this.contacts);
        
    // }
    // onNext() {
        
    //     if (this.start + this.perSize < this.contacts.length) {
    //         this.start += this.perSize;
    //         this.updateDisplayContacts();
    //         this.pageCount += 1
    //         console.log('Total pages ---- ',Math.floor(this.contacts.length / this.perSize));
    //     } else {
    //         console.log("No more contacts to display.");
    //     }
    // }
    // onPrevious() {
        
    //     if (this.start - this.perSize >= 0) {
    //         this.start -= this.perSize;
    //         this.updateDisplayContacts();
    //         this.pageCount-=1
    //     } else {
    //         console.log("No previous contacts to display.");
    //     }
    // }

}




