import { LightningElement,wire } from 'lwc';
import recordsFormSelectAccount from '@salesforce/apex/RecordsFormSelectAccount.recordsFormSelectAccount'

export default class RecordsFormSelectAccount extends LightningElement {
  
    accountSelected;
    allAccounts=[];
    @wire(recordsFormSelectAccount )
    wiredRecords({ data, error }) {
        if (data!==undefined) {
           console.log('Data in recordsFormSelectAccount == ',JSON.stringify(data))
           console.log('Data type in recordsFormSelectAccount == ',typeof data)
            data.forEach(each => {
                const eachAccount ={ label:each.Name, value:each.Id}
                this.allAccounts.push(eachAccount)
            })
            console.log('All Accounts == ',this.allAccounts)
            console.log('All Accounts == ',JSON.stringify(this.allAccounts))
            const accountsEvent = new CustomEvent('displayaccounts', {'detail': this.accounts })
            this.dispatchEvent(accountsEvent)
            console.log('List of Accounts data == ',JSON.stringify(data))
        }
        else if (error) {
            console.log('Error occured == ',error)
        }
    }

    get options() {
        console.log('In Options, All Accounts == ',JSON.stringify(this.allAccounts))
        return this.allAccounts
    }
    handleChange(event) {
        this.accountSelected=event.target.value
    }
}