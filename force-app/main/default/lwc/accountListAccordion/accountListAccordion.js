import { LightningElement,wire } from 'lwc';
import accountList from '@salesforce/apex/RecordsFormSelectAccount.recordsFormSelectAccount'
export default class AccountListAccordion extends LightningElement {
    accountsList;
    accountId;
    @wire(accountList) 
    wiredData({ data, error }) {
        if (data) {
            console.log('Data == ', data)
            this.accountsList = data.map(account => account);
        }
        else if (error) {
            console.log('Error Occured! Error : ',JSON.stringify(error))
        }
    }
    
//     handleClick(event) {
// this.accountId = event.target.name
//         console.log('Account Clicked == ',this.accountId)
//     }
    get accountIdFromParent() {
        return this.accountId;
    }
}