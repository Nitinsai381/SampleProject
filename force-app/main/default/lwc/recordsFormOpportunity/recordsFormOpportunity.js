import { LightningElement } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";
import OPPORTUNITY_OBJECT from "@salesforce/schema/Opportunity";
import OPP_NAME_FIELD from "@salesforce/schema/Opportunity.Name";
import CLOSE_DATE_FIELD from "@salesforce/schema/Opportunity.CloseDate";
import STAGE_FIELD from "@salesforce/schema/Opportunity.StageName";
import ACCOUNT_ID_FIELD from "@salesforce/schema/Opportunity.AccountId";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class RecordsFormOpportunity extends LightningElement {
    oppNameValue;
    closeDateValue;
    stageValue;
    accountIdValue;
    showModal = true;

    get stageOptions() {
        return [{ label: 'Prospecting', value: 'Prospecting' }, { label: 'Qualification', value: 'Qualification' }, { label: 'Needs Analysis', value: 'Needs Analysis' }, { label: 'Needs Analysis', value: 'Needs Analysis' }, { label: 'Closed Won', value: 'Closed Won' }, { label: 'Closed Lost', value: 'Closed Lost' }];
    }
    handleInput(event) {
        if (event.target.name === 'oppName') {        
            this.oppNameValue = event.target.value
            console.log('oppName == ',this.oppNameValue)
        }
        else if (event.target.name === 'closeDate') {
            this.closeDateValue = event.target.value
            console.log('closeDate == ',this.closeDateValue)
        }
        else if (event.target.name === 'stage') {          
            this.stageValue = event.target.value
            console.log('Stage == ',this.stageValue)
        }
 
    }
    handleSelectAccount(event) {
        this.accountIdValue = event.detail
        console.log('Selected account in Opportunity == ',this.accountIdValue)
    }
    handleCreate() {
        const fields = {}
        fields[OPP_NAME_FIELD.fieldApiName]=this.oppNameValue
        fields[CLOSE_DATE_FIELD.fieldApiName]=this.closeDateValue
        fields[STAGE_FIELD.fieldApiName]=this.stageValue
        fields[ACCOUNT_ID_FIELD.fieldApiName]=this.accountIdValue
        const record = { apiName: OPPORTUNITY_OBJECT.objectApiName, fields }
        createRecord(record).then(recordOpp => {
            const notifyToast = new ShowToastEvent({
                title: "Opportunity created successfully!",
                message: "Opportunity created with Id : "+ recordOpp.id,
                variant:"success"
            })
            console.log('New Opportunity Id ==== ',recordOpp.id)
            this.dispatchEvent(notifyToast)
            this.showModal=false
        }).catch(error => {
            const notifyToast = new ShowToastEvent({
                title: "Opportunity creation failed!",
                message: "Try creating again by solving issues" + error[0],
                variant: "error"
            })
            this.dispatchEvent(notifyToast)
        })
    }
    handleSave() {
        this.handleCreate()
    }
}