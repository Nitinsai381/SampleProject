import { api, LightningElement,wire } from 'lwc';
import dynamicTableData from '@salesforce/apex/DynamicTable.dynamicTableDataHere';
export default class DynamicTable extends LightningElement {
    @api recordId
    ObjectValue;
    columnLabels;
    ObjectTableValues;
    structuredData;
    recordsData;
    labelsData;
    isEmpty;
    newValues;
    values=[];
    search = false;
    isSearch = false;
    perSize = 5;
    start = 0;
    totalPages;
    pageCount = 1;
    slicedContactsArray;
    handleSelect(event) {
        this.ObjectValue = event.detail.value;
        this.search =false;
        console.log('DynamicTable here, DropDown Selected value ==== ', this.ObjectValue)
        console.log(event.detail.value);
    }
    updateValues(event) {
        this.values = event.detail.value;
        this.search = event.detail.search;
        console.log('values in updatevalues ==== ',JSON.stringify(this.values))
        console.log('Search in updatevalues ==== ', event.detail.search)
        this.structure()
    }
    @wire(dynamicTableData, ({ id: '$recordId', objectName: '$ObjectValue' }))
    wiredData({ data, error }) {
        if (data) {
            this.isEmpty = (data.data.objectType.length > 0)
            console.log('isEmpty ====',this.isEmpty)
            console.log('Data here ==== ', data)
            // console.log('Data here ==== ', data[1].objectType)
            // console.log('Data here ==== ', data[0].columns[0].Field_Config__r)
           // this.ObjectTableValues = data[0]
            // this.columnLabels = data.data.columns.map(column => {
            //     return column.Field_Config__r
            // })
            console.log('columnLabels here ==== ', JSON.stringify(this.columnLabels))
            // this.ObjectTableValues = {columns : this.columnLabels, records : data[1].objectType}
            this.recordsData = data.data.objectType;
            this.labelsData=data.data.columns
            console.log('ObjectTableValues here ==== ', JSON.stringify(this.ObjectTableValues))
            console.log('labelsData here ==== ', JSON.stringify(this.labelsData))
            console.log('recordsData here ==== ', JSON.stringify(this.recordsData))
            this.isSearch = this.recordsData.length > 5
            console.log('Search ==== ',this.search)
            console.log('values before if ==== ',JSON.stringify(this.values))
            this.structure()
            this.updateDisplayContacts()
        }
        else if (error) {
            console.log('Error occurred in fetching data..')
        }

    }
                  
    structure() {  
        if (this.search) {
            this.newValues = this.values;
            
            console.log('values inside if ==== ',JSON.stringify(this.values))
        }
        else {
            this.newValues=this.recordsData
        }
        
        this.structuredData = this.newValues.map(contact =>{
            let obj={};
            obj.Id =contact.Id;
            obj.record=this.buildRecord(contact);
            return obj;
        });
        console.log('structuredData----', JSON.stringify(this.structuredData));
        this.totalPages = Math.ceil(this.structuredData.length / this.perSize);
        
        console.log('isSearch ==== ', this.isSearch)
        this.start=0
        this.updateDisplayContacts()
    }
    
    buildRecord(contact){
        let record=[];
        this.labelsData.forEach(col => {
            record.push(contact[col.Field_Api_Name]);
        
        });
        return record;
    }

    updateDisplayContacts() {
        // this.slicedContactsArray = this.structuredData.slice(this.start, this.start + this.perSize);
        this.slicedContactsArray = this.structuredData.slice(this.start, this.start + this.perSize);
        console.log("Sliced structuredData for pagination -- "+ JSON.stringify(this.slicedContactsArray));
        
    }
    
    onNext() {
        
        if (this.start + this.perSize < this.structuredData.length) {
            this.start += this.perSize;
            this.updateDisplayContacts();
            this.pageCount += 1
            console.log('Total pages ---- ',Math.floor(this.structuredData.length / this.perSize));
        } else {
            console.log("No more contacts to display.");
        }
    }
    onPrevious() {
        
        if (this.start - this.perSize >= 0) {
            this.start -= this.perSize;
            this.updateDisplayContacts();
            this.pageCount-=1
        } else {
            console.log("No previous contacts to display.");
        }
    }
    get isPreviousDisable() {
        // let isDisable = true;
        return (this.start === 0)
            
        //     isDisable = false;
        // }
        // return isDisable;
    }
    get isNextDisable() {
        return ((this.structuredData.length - this.start) <= this.perSize)
    }
}