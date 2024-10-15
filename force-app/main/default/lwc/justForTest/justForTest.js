import { LightningElement,wire,api } from 'lwc';
import dynamicTableDataHere from '@salesforce/apex/DynamicTable.dynamicTableDataHere';
export default class JustForTest extends LightningElement {
    @api recordId;
    ObjectValue ='Contact'
    @wire(dynamicTableDataHere, ({ id: '$recordId', objectName: '$ObjectValue' }))
    wiredData({ data, error }) {
        if (data) {
            console.log('Data from -Just for test- ==== ', JSON.stringify(data));
        }
        else if (error) {
            console.log('Error occurred!!')
        }
    }
}