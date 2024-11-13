import { LightningElement,api,track } from 'lwc';

export default class RelatedRecordsAccTable extends LightningElement {
    @api contactsList = [];
    @api oppsList= [];
    @api caseList= [];
    @api objectName;
    @track structuredData = []
    @track recordsList=[]
 
    // recordsInFalse=JSON.stringify(this.recordsList)
    //console.log('contactsList',contactsList)
    //api
    // renderedCallback() {
    //     console.log('contactsList', JSON.stringify(this.contactsList));
    // }
    connectedCallback() {
        console.log('I am in structuringData..')
        console.log('contactsList', JSON.stringify(this.contactsList));
        
        this.notEmptyCons = this.contactsList.length>0
        this.notEmptyOpps = this.oppsList.length>0
        this.notEmptyCase = this.caseList.length > 0
        this.notEmpty=(this.notEmptyCase || this.notEmptyCons || this.notEmptyOpps)
        console.log('notEmptyCons',JSON.stringify(this.notEmptyCons))
        console.log('notEmptyOpps',JSON.stringify(this.notEmptyOpps))
        console.log('notEmptyCase',JSON.stringify(this.notEmptyCase))
        // structuredData = [];
        //labelsData=(this.contactsList!==undefined)?(this.contactsList[0].keys()):null;
        if (this.notEmptyCons) {
            this.recordsList=this.contactsList
        }
        else if (this.notEmptyOpps) {
            this.recordsList=this.oppsList
        }
        else if (this.notEmptyCase) {
            this.recordsList=this.caseList
        }
        this.labelsData = (this.recordsList && this.recordsList.length > 0)
        ? Object.keys(this.recordsList[0])
        : [];
    this.labelsData.shift()
    console.log('labelsData', JSON.stringify(this.labelsData));
    
            
            this.structuredData = (this.recordsList)?this.recordsList.map(recs =>{
                let obj = {};
                console.log('StructuredData recs == ',recs)
                obj.Id =recs.Id;
                obj.record=this.buildRecord(recs);
                return obj;
            }) : null;
        console.log('StructuredData == ',JSON.stringify(this.structuredData))
    
    }
    
        buildRecord(recs){
            let record=[];
            this.labelsData.forEach(col => {
            
                    record.push(recs[col]);
                
            });
            return record;
        }
}