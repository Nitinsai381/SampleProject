import { LightningElement,wire } from 'lwc';
import caseActivities from '@salesforce/apex/CaseActivity.caseActivities'

export default class ActivitiesCases extends LightningElement {
 
    dateOptions=[];
    typesOptions=[];
    statusOptions=[];
    valueTime = 'few'
    initialTime;
    caseList = ["Case 19294690 Testing E2c Forward","Case 19294456 Testing E2d Backward"]
    @wire(caseActivities)   
    wiredData({ data, error }) {
        if (data) {
            this.initialTime = new Date().getTime();
            
            console.log('Data == ', JSON.stringify(Object.values(data)))
            this.caseActivityRaw = Object.values(data).map(each => {
                let obj = {}
                obj.label = each.Label
                obj.order = each.OrderNumber__c
                obj.value = each.DeveloperName
                return obj
            });
            this.caseActivityRaw.sort((a,b)=> a.order -b.order)
            console.log('case Activities Raw inside if == ', JSON.stringify(this.caseActivityRaw))
            
        }
        else if (error) {
            console.log('Error Occurred == ',error)
        }
        console.log('case Activities Raw outside if == ', JSON.stringify(this.caseActivityRaw))
        this.structuring()
       
    }
    structuring() {
        let arr = [];
        let arr2 = [];
        let arr3=[]
        console.log('Inside structuirng -- ',this.caseActivityRaw)
        if (this.caseActivityRaw) {
            
        
            this.caseActivityRaw.forEach(each => {
         
                if (each.order > 1 && each.order < 2) {
              
                    arr.push({ label: each.label, value: each.value })
                    this.dateOptions = arr;
                    console.log(this.dateOptions);
                }
               
                else if (each.order > 2 && each.order < 3) {
                    
                    arr2.push({ label: each.label, value: each.value })
                    this.typesOptions=arr2
                }
                else if (each.order > 3 && each.order < 4) {
                    arr3.push({ label: each.label, value: each.value })
                    this.statusOptions=arr3
                }
            })
            this.dateValue=this.dateOptions[0].value
            this.typeValue=this.typesOptions[0].value
            this.statusValue=this.statusOptions[0].value
            console.log('Date options == ', JSON.stringify(this.dateOptions))
            console.log('Type options == ', JSON.stringify(this.typesOptions))
            console.log('Status options == ', JSON.stringify(this.statusOptions))
        }
    }
    handleDateChange(event) {
        this.dateValue = event.target.value
        console.log('Date value == ',this.dateValue)
    }
    handleTypeChange(event) {
        this.typeValue = event.target.value
        console.log('Type value == ',this.typeValue)
    }
    handleStatusChange(event) {
        this.statusValue = event.target.value
        console.log('Status value == ',this.statusValue)
    }
    handleRefresh() {
        this.template.querySelector('.date').value=this.dateOptions[0].value
        this.template.querySelector('.type').value=this.typesOptions[0].value
        this.template.querySelector('.status').value=this.statusOptions[0].value
    }

    renderedCallback() {
        
        const initTime = this.initialTime
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        setInterval(() => {
            
            var now = new Date().getTime();
            var distance = now - initTime;
            var days = Math.floor(distance / (1000 * 60 * 60 * 24));
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);
            if ((seconds < 60) && minutes < 1) {
              
                this.valueTime = `Last updated few seconds ago.`
            }
            else if ((minutes >= 1)) {
                if (minutes === 1) {
                    
                    this.valueTime = 'Last updated ' + minutes + ' minute ago.'
                } else {
                    
                    this.valueTime = 'Last updated ' + minutes + ' minutes ago.'
                }
            }
            else if ((hours >= 1)) {
                if (hours === 1) {
                    
                    this.valueTime = 'Last updated ' + hours + ' hours ago.'
                } else {
                    
                    this.valueTime = 'Last updated ' + hours + ' hours ago.'
                }
            }
            else if ((days >= 1)) {
                if (days === 1) {
                    
                    this.valueTime = 'Last updated ' + days + ' days ago.'
                } else {
                    
                    this.valueTime = 'Last updated ' + days + ' days ago.'
                }
            }
          
            // console.log(`initial time ${initTime} and current time ${now}`);
        }, 1000);
    }
    }