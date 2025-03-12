import { LightningElement,api ,track} from 'lwc';
import relatedObjectsList from '@salesforce/apex/RecordsFormSelectAccount.relatedObjectsList';
export default class RelatedRecordsAccordions extends LightningElement {
    @api accountId;
    objectType;
    // contactsData = []
    // oppsData = []
    // caseData=[]
    @track recordsData = [];
    isClicked = false
    objectValueCon=false
    objectValueOpp=false
    objectValueCase = false
   
    // isContact = this.objectType === 'Contact'
    // isOpp = this.objectType === 'Opportunity'
    // isCase = this.objectType === 'Case'
    handleClick(event) {
        this.objectType = event.target.name;  
        this.isClicked = true;
      
        relatedObjectsList({ accId: this.accountId, objectName: this.objectType })
            .then(result => {
                
                console.log('result:', result);
                this.isClicked = false;
                const resultData = result ? result.map(each => each) : null;
                this.recordsData = resultData;
  
                console.log('recordsData:', JSON.stringify(this.recordsData));
    
                this.objectValueCon = this.objectType === 'Contact';
                this.objectValueOpp = this.objectType === 'Opportunity';
                this.objectValueCase = this.objectType === 'Case';
         
                console.log('objectValueCon:', this.objectValueCon);
                console.log('objectValueOpp:', this.objectValueOpp);
                console.log('objectValueCase:', this.objectValueCase);
                console.log('Clicked Object Name:', this.objectType);
                console.log('Account Id in records:', this.accountId);
            })
            .catch(error => {
                console.log('Error occurred:', error);
            });
    }
    
    }

    // @wire(relatedObjectsList, ({ accId: '$accountId', objectName:'$objectType'}))
    // wiredData({ data, error }) {
    //     if (data) {
    //         // this.recordsData=data.map(each=>each)
    //         console.log('Account Id == ', this.accountId)
    //         // console.log('Object Name == ', this.objectType)
    //         // console.log('recordData == ', JSON.stringify(data))
    //         this.recordsData=data!==undefined?data.map(each=> each):null
    //         console.log('recordsData == ',JSON.stringify(this.recordsData))
    //         // this.oppsData=data!==undefined?data.opportunities.map(each=> each):null
    //         // console.log('oppsData == ',JSON.stringify(this.oppsData))
    //         // this.caseData=data!==undefined?data.cases.map(each=> each):null
    //         // console.log('caseData == ',JSON.stringify(this.caseData))
    //     }
    //     else if (error) {
    //         console.log('Error occurred!');
    //     }
    // }
    // get recordsDataList() {
    //     // console.log('recordsData outside wire == ', JSON.stringify(this.recordsData))
    //     return this.isClicked?this.recordsData:[] ;
    // }