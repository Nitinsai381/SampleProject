import { LightningElement,wire } from 'lwc';
import recordsFormSelectAccount from '@salesforce/apex/RecordsFormSelectAccount.recordsFormSelectAccount'

export default class RecordsFormSelectAccount extends LightningElement {
    accounts;
    accountSelected;
    allAccounts=[];
    @wire(recordsFormSelectAccount )
    wiredRecords({ data, error }) {
        if (data!==undefined) {
        //    console.log('Data in recordsFormSelectAccount == ',JSON.stringify(data))
        //     console.log('Data type in recordsFormSelectAccount == ', typeof data)
            this.accounts = data
             this.allAccounts=this.accounts.map(each => {
                 return { label: each.Name, value: each.Id }
                  
            
        })
            // console.log('this.accounts == ',JSON.stringify(this.accounts))
            // console.log('All Accounts == ',this.allAccounts)
            // console.log('All Accounts == ',JSON.stringify(this.allAccounts))
            // const accountsEvent = new CustomEvent('displayaccounts', {'detail': this.accounts })
            // this.dispatchEvent(accountsEvent)
            // console.log('List of Accounts data == ',JSON.stringify(data))
        }
        else if (error) {
            console.log('Error occured == ',error)
        }
    }
    // allAccountsOptions = this.allAccounts;
    
    get accountOptions() {
        // console.log('this.allAccounts', JSON.stringify(this.allAccounts));
        // this.accounts.forEach(each => {
                
        //     this.allAccounts.push({label:each.Name, value:each.Id})
        // // })
        // console.log('In Options, All Accounts == ',JSON.stringify(this.allAccounts))
        return this.allAccounts
    }
    handleChange(event) {
        this.accountSelected = event.target.value
        // console.log('Account selected == ', this.accountSelected)

            this.dispatchEvent(new CustomEvent('displayaccounts', {'detail': this.accountSelected }))
    }
}