// import { LightningElement,api } from 'lwc';

// export default class Demo extends LightningElement {

//     @api message = 'jagadeesh';
//     @api recordId;
// }
import { LightningElement, api, track, wire } from 'lwc';
import getContactsByAccountId from '@salesforce/apex/ContactController.getContactsByAccountId';
import updateContacts from '@salesforce/apex/ContactController.updateContacts';
export default class CustomDataTable extends LightningElement {
    @api recordId; // Account ID passed from the parent component
    @track contacts = [];
    
    @wire(getContactsByAccountId, { accountId: '$recordId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.map(contact => ({ ...contact, isEditing: false }));
        } else if (error) {
            console.error('Error loading contacts', error);
        }
    }
    handleEdit(event) {
        const contactId = event.target.dataset.id;
        this.contacts = this.contacts.map(contact => 
            contact.Id === contactId ? { ...contact, isEditing: true } : contact
        );
    }
    handleFieldChange(event) {
        const contactId = event.target.dataset.id;
        const field = event.target.dataset.field;
        const newValue = event.target.value;
        this.contacts = this.contacts.map(contact => 
            contact.Id === contactId ? { ...contact, [field]: newValue } : contact
        );
    }
    handleSave(event) {
        const contactId = event.target.dataset.id;
        const contactToUpdate = this.contacts.find(contact => contact.Id === contactId);
        if (contactToUpdate) {
            updateContacts({ contactsToUpdate: [contactToUpdate] })
                .then(() => {
                    // Reloading the contacts after saving is handled by the wired method
                    this.contacts = this.contacts.map(contact => 
                        contact.Id === contactId ? { ...contact, isEditing: false } : contact
                    );
                })
                .catch(error => {
                    console.error('Error updating contacts', error);
                });
        }
    }
    handleCancel(event) {
        const contactId = event.target.dataset.id;
        this.contacts = this.contacts.map(contact => 
            contact.Id === contactId ? { ...contact, isEditing: false } : contact
        );
    }
}
public with sharing class ContactController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId) {
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :accountId];
    }
    @AuraEnabled
    public static void updateContacts(List<Contact> contactsToUpdate) {
        update contactsToUpdate;
    }
}
