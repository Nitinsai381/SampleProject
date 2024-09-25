import { LightningElement,wire,api } from 'lwc';
import accountContacts from '@salesforce/apex/AccountRelatedContacts.relatedContactsTable';

export default class accountRelatedContacts extends LightningElement {
    @api recordId;
    contacts;
    // dynamicContacts={};
    labels=[];
    contactData = [];
    contactsArray = [];
    slicedContactsArray ;
    contactKeys=[];
    notEmpty = false;
    perSize = 5;
    start = 0;
    totalPages;
    pageCount = 1;
    @wire(accountContacts, { accId: '$recordId' })
    wiredData({ data, error }){
        if (data) {
            console.log(data);
            console.log(typeof data);
            this.contacts = data;
            // this.contacts =() => {
            //     data.slice(this.start, this.start + this.perSize);
            //    // console.log("data" + this.contacts);
                
            // };
            
            this.notEmpty = this.contacts[1].contacts.length > 0;
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
            this.labels = this.contacts[0].columns;
            console.log('Data in labels after slice ---- ', JSON.stringify(this.labels));
            this.contactData = this.contacts[1].contacts;
            console.log('Data in contacts after slice ---- ', JSON.stringify(this.contactData));
            this.labels = this.labels.map(label => label.Column__c);
            console.log('Data in labels ---- ', JSON.stringify(this.labels));

            // this.contactKeys = this.labels.map(column =>column.replace(' ', '.') );
                
           
            // console.log('Keys in contacts from labels ===== ',JSON.stringify(this.contactKeys))
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

            console.log('Contacts in contactData ==== ',JSON.stringify(this.contactData))
            //VC
            this.structuredData = this.contactData.map(contact =>{
                let obj={};
                obj.Id =contact.Id;
                obj.record=this.buildRecord(contact);
                return obj;
            });
            console.log('structuredData----', JSON.stringify(this.structuredData));
            this.totalPages = Math.ceil(this.structuredData.length / this.perSize);

       // - VC
        
//Mine==
            // this.contactsArray = this.contactData[0].contacts.map(contact => {
            //     return this.contactKeys.map(key => {
                    
            //         return key.split('.').reduce((obj, prop) => obj && obj[prop], contact) || null;
            //     });
            // });
            // console.log('Contacts in ContactsArray ==== ', JSON.stringify(this.contactsArray));
            this.updateDisplayContacts();
          
        }
        else if (error) {
            this.error = error;
            this.contacts = [];
            this.notEmpty = false;
            console.log("Error in fetching data..")
        }
    }
    //VC
    buildRecord(contact){
        let record=[];
        this.labels.forEach(col => {
            record.push(contact[col]);
        
        });
        return record;
    }
    //--VC

    updateDisplayContacts() {
        // this.slicedContactsArray = this.structuredData.slice(this.start, this.start + this.perSize);
        this.slicedContactsArray = this.structuredData.slice(this.start, this.start + this.perSize);
        console.log("Sliced structuredData for pagination -- "+ this.slicedContactsArray);
        
    }
    onNext() {
        
        if (this.start + this.perSize < this.structuredData.length) {
            this.start += this.perSize;
            this.updateDisplayContacts();
            this.pageCount += 1
            console.log('Total pages ---- ',Math.floor(this.structuredData.length / this.perSize));
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
    get isPreviousDisable() {
        // let isDisable = true;
        return (this.start === 0)
            
        //     isDisable = false;
        // }
        // return isDisable;
    }
    get isNextDisable() {
        return ((this.structuredData.length - this.start) <= this.perSize)
    }

}

// Varshith bro's clue code..
// * a = [
//     *  {label : "Name", ApiName : "Name"}
//     *  {label : "Email", ApiName : "Email"}
//     *  {label : "Phone", ApiName : "Phone"}
//     * ]
//     */
   /**
    * b = [
    * {ID : "003aa", Name : "rec1", Email : "rec1@test.com", Phone : "123"}
    * {ID : "003bb", Name : "rec2", Email : "rec2@test.com", Phone : "456"}
    * {ID : "003cc", Name : "rec3", Email : "rec3@test.com", Phone : "678"}
    * ]
    *
    * /[
    *  {Id : "003", record : [values]}
    * ]/
    *  this.structuredData = b.map(e =>{
    *      let obj = {};
    *      obj.Id = e.Id;
    *      obj.record = this.buildRecord(e);
    *      return obj;
    * });
    *
    * buildRecord(obj o){
    *  [name, email, phome];
    *  let x = a.map(e =>{
    *      let y = [];
    *      for( let col in e){
    *          y.push(o[e.ApiName])
    *      }
    *      return y;
    *  })
    * return x;
    * }
    */



