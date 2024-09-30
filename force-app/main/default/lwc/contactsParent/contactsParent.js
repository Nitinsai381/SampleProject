import { LightningElement, wire} from 'lwc';
import contactsListInLWC from '@salesforce/apex/ContactsInLwcTask.contactsListInLWC';
export default class ContactsParent extends LightningElement {
    // @api contacts;
    isEmpty = true
    contacts
    contactId
    contact
    clicked=false
    @wire(contactsListInLWC) 
    wiredData(data, error) {
        if (data) {
            this.contacts = data.data;
            this.isEmpty = false;
            console.log('isEmpty ==== ',this.isEmpty);
            
            console.log('Data available ==== ',JSON.stringify(this.contacts))
        }
        else if (error) {
            console.log('Error in fetching data')
        }
    }
    handleClick(event) {
        this.contactId = event.target.dataset.id;
        this.clicked = true;
        this.contact = this.contacts.find(contact => contact.Id === this.contactId)
        console.log('Contact Id ==== ', event.target.dataset.id);
        console.log('contact with id ==== ',this.contact)
        console.log('Clicked ==== ', this.clicked);
    }
}