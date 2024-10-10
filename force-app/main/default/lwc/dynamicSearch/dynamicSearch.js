import { LightningElement,api } from 'lwc';

export default class DynamicSearch extends LightningElement {
    @api recordList;
    @api labelList;
    structuredData;
    searchedValue
    searchedContacts = []
    anotherCheck=false
    isSearched = false
    contactsEmpty = true
   
    handleSearch(event) {
        this.searchedValue=event.target.value
        // this.searchedValue = this.template.querySelector("input").value
        this.isSearched=true
        console.log('letters entered ==== ', this.searchedValue)
        console.log('recordList in dynamicsearch====',JSON.stringify(this.recordList))
        console.log('Searched contacts ==== ',JSON.stringify(this.searchContacts))
        const searched = new CustomEvent('searchedobject', { detail:{'value':this.searchContacts,'search':true}});
        this.dispatchEvent(searched);
    }
    get searchContacts() {
        this.searchedContacts = []
        this.recordList.forEach(contact => {
            if (contact.Name.toLowerCase().startsWith(this.searchedValue.toLowerCase())) {
                this.searchedContacts.push(contact)
            }               
        })
        this.recordList.forEach(contact => {
            if (!contact.Name.toLowerCase().startsWith(this.searchedValue.toLowerCase()) && (contact.Name.toLowerCase().includes(this.searchedValue.toLowerCase()))) {
                this.searchedContacts.push(contact)
            }           
        })
        if (this.searchedContacts.length > 0) {
            this.contactsEmpty = false
        }
        console.log('Searched contacts ==== ', this.searchedContacts)
        return this.searchedContacts;
    }
}