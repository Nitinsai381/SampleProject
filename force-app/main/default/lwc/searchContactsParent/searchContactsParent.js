import { LightningElement,wire,api } from 'lwc';
import contactsListInLWC from '@salesforce/apex/ContactsInLwcTask.contactsListInLWC';
export default class SearchContactsParent extends LightningElement {
    contactsList=[]
    searchedValue
    searchedContacts = []
    anotherCheck=false
    isSearched = false
    contactsEmpty = true
    @wire(contactsListInLWC)  
    wiredData({ data, error }) {
        if (data) {
            this.contactsList= data;
            console.log('Contacts list ==== ',JSON.stringify(this.contactsList))
            // console.log('Contacts list data ==== ',JSON.stringify(Object.entries(data)))
            console.log('Contacts type ==== ', typeof this.contactsList)
          
        }
        else if (error) {
            console.log('Error message ==== ',this.error)
        }
        
    }
    
    // handleSearch(event) {
    //     this.searchedValue = event.target.value;
    //     console.log('letters entered ==== ',event.target.value)
    // }
    handleSearch() {
        this.searchedValue = this.template.querySelector("input").value
        this.isSearched=true
        console.log('letters entered ==== ', this.searchedValue)
        this.searchContacts();
        console.log('Searched contacts ==== ',JSON.stringify(this.searchedContacts))
        
    }
    @api
    searchContacts() {
       // let searchedValuetemp = '0';
       
            
            this.contactsList.forEach(contact => {
                if (contact.Name.toLowerCase().startsWith(this.searchedValue.toLowerCase())) {
                    this.searchedContacts.push(contact)
                }
                
            })
            this.contactsList.forEach(contact => {
                if (!contact.Name.toLowerCase().startsWith(this.searchedValue.toLowerCase()) && (contact.Name.toLowerCase().includes(this.searchedValue.toLowerCase()))) {
                    this.searchedContacts.push(contact)
                }
                
            })
            if (this.searchedContacts.length > 0) {
                this.contactsEmpty=false
            }
            console.log('Searched contacts ==== ', this.searchedContacts)
           // searchedValuetemp=this.searchedValue
    
        
    }


    connectedCallback() {
        this.isSearched = false;
        if (this.searchedValue != null) {
            
            this.handleSearch();
        }
        let searchedValuetemp='0'
        // this.searchedContacts.clear()
        if (this.searchedValue !== searchedValuetemp) {
            this.searchContacts();
            console.log('this.searchContacts-->'+this.searchedContacts);
        }
    }
    // handleUpdateChild(){
    //     this.template.querySelector('c-search-contacts-child').contactsfound = this.searchedContacts;
    // }

}