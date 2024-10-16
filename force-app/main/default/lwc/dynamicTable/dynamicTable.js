import { api, LightningElement,wire } from 'lwc';
import dynamicTableData from '@salesforce/apex/DynamicTable.dynamicTableDataHere';
export default class DynamicTable extends LightningElement {
    @api recordId
    ObjectValue;
    columnLabels;
    ObjectTableValues;
    structuredData;
    searchedContacts=[];
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
    disableNextPrev = true;
    showSpinner;
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
        // this.search ? this.searchData() : this.structure()
        if (this.search) {
            this.searchData()
        }
        else {
            this.structure()
        }
    }
    @wire(dynamicTableData, ({ id: '$recordId', objectName: '$ObjectValue' }))
    wiredData({ data, error }) {
        if (data) {
            this.isEmpty = (data.objectType.length > 0)
            console.log('isEmpty ====',this.isEmpty)
            console.log('Data here ==== ', data)
            // console.log('Data here ==== ', data[1].objectType)
            // console.log('Data here ==== ', data[0].columns[0].Field_Config__r)
           // this.ObjectTableValues = data[0]
            // this.columnLabels = data.data.columns.map(column => {
            //     return column.Field_Config__r
            // })
            this.showSpinner=true
            console.log('columnLabels here ==== ', JSON.stringify(this.columnLabels))
            // this.ObjectTableValues = {columns : this.columnLabels, records : data[1].objectType}
            this.recordsData = data.objectType;
            this.labelsData= data.columns
            console.log('ObjectTableValues here ==== ', JSON.stringify(this.ObjectTableValues))
            console.log('labelsData here ==== ', JSON.stringify(this.labelsData))
            console.log('recordsData here ==== ', JSON.stringify(this.recordsData))
            this.isSearch = this.recordsData.length > 5
            console.log('Search ==== ',this.search)
            console.log('values before if ==== ',JSON.stringify(this.values))
            // if (this.search) {
            //     this.searchData()
            // }
            // else {
                this.structure()
            // }
            this.updateDisplayContacts()
        }
        else if (error) {
            this.showSpinner=false

            console.log('Error occurred in fetching data..')
        }

    }
//   searchContacts() {
//        this.recordsData.forEach(value => {
           
                 
//             //    value.record.forEach(each => {
//             //        if (each.toLowerCase().startsWith(this.values.toLowerCase())) {
//             //                  this.searchedContacts.push(value)
//             //              }
//             //    })
//             //    value.record.forEach(each => {
//             //       if (!each.toLowerCase().startsWith(this.values.toLowerCase()) && (each.toLowerCase().includes(this.values.toLowerCase()))) {
//             //           this.searchedContacts.push(value)
//             //       }           
//             //   })
//            this.searchedContacts.push(value)
       
//          })

//        console.log('Data in SearchedContacts from dynamic table ==== ',JSON.stringify(this.searchedContacts))
//     //    return this.searchedContacts
//            }       
    structure() {  
       this.structuredData=[]
        this.structuredData = this.recordsData.map(contact =>{
            let obj={};
            obj.Id =contact.Id;
            obj.record=this.buildRecord(contact);
            return obj;
        });
        console.log('structuredData----', JSON.stringify(this.structuredData));
        this.totalPages = Math.ceil(this.structuredData.length / this.perSize);
        this.disableNextPrev = (this.structuredData.length / this.perSize)>1
        console.log('disableNextPrev initially == ',this.disableNextPrev)
        console.log('isSearch ==== ', this.isSearch)
 

            // if (this.search) {
              
             
            // }
            // else {
            //     this.newValues = this.structuredData
            
            // }
        
        if (this.search === false) {
            this.newValues=[]
            this.newValues=this.structuredData
        }
        this.start=0
        this.updateDisplayContacts()
    }
    
    searchData() {
        this.searchedContacts = []
        if (this.values === '') {
            this.searchedContacts=[]
            this.searchedContacts = this.structuredData
           
        } else {
            this.searchedContacts = []
            this.structuredData.forEach(value => {
                 
                value.record.forEach(each => {
                    if (each !== undefined) {
                        // each=''
                        if (each.toLowerCase().startsWith(this.values.toLowerCase())) {
                            console.log('each in search logic startsWith====',each)
                            console.log('Value.record startsWith====',JSON.stringify(value.record))
                            this.searchedContacts.push(value)
                            
                            
                        }
                        if (!(each.toLowerCase().startsWith(this.values.toLowerCase()) && each.toLowerCase().includes(this.values.toLowerCase())) && each.toLowerCase().includes(this.values.toLowerCase())) {
                            console.log('each in search logic includes====',each)
                            console.log('Value.record startsWith====',JSON.stringify(value.record))
                            this.searchedContacts.push(value)
                        }
                    }
                })
    
         })
        }
        this.pageCount=1
        this.newValues = []
        const someSet = new Set(this.searchedContacts)
      this.newValues=[...someSet]
        this.totalPages = Math.ceil(this.newValues.length / this.perSize);
        this.disableNextPrev = (this.newValues.length / this.perSize)>1
        console.log('disableNextPrev in search and pagination == ',this.disableNextPrev)
        // this.search=false
        console.log('values inside if ==== ',JSON.stringify(this.newValues))
        console.log('values inside if without actual ==== ')
        this.start = 0
        console.log('newValues in search ---- ',JSON.stringify(this.newValues));
            
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
        console.log('newValues in pagination ---- ',JSON.stringify(this.newValues));
        this.slicedContactsArray = this.newValues.slice(this.start, this.start + this.perSize);
        console.log("Sliced structuredData for pagination -- "+ JSON.stringify(this.slicedContactsArray));
        
    }
    
    onNext() {
        
        if (this.start + this.perSize < this.newValues.length) {
            this.start += this.perSize;
            this.updateDisplayContacts();
            this.pageCount += 1
            console.log('Total pages ---- ',Math.floor(this.newValues.length / this.perSize));
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
console.log('onPrevious disable -- ', ((this.pageCount === 1) && (this.start===0)))
        return ((this.pageCount === 1) || (this.start===0))
    }
    get isNextDisable() {
        return ((this.newValues.length - this.start) <= this.perSize)
    }
    // get nextPrev() {
    //     console.log('Next  value ==== ',(this.isNextDisable ))
    //     console.log('Previous value ==== ',( this.isPreviousDisable))
    //     console.log('Next and Previous value ==== ',(this.isNextDisable || this.isPreviousDisable))
    //     return (this.isNextDisable || this.isPreviousDisable)
    // }
}