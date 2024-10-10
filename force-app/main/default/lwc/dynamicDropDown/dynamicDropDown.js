import { LightningElement,api} from 'lwc';

export default class DynamicDropDown extends LightningElement {
    @api recordId;

    value;
    get isdisabled() {
        console.log('recordId====',this.recordId)
        return (this.recordId.charAt(2)==='1'? true:false)
    }
    get options() {
        return [{ label: 'Case', value: 'Case' }, { label: 'Contact', value: 'Contact' }, { label: 'Opportunity', value: 'Opportunity' }];
    }
    handleChange(event) {
        this.value = event.detail.value;
        const selected = new CustomEvent('selectobject', { detail:{'value':this.value}  });
        this.dispatchEvent(selected)
        console.log('Child DropDown clicked value ==== ',this.value)
    }
    // handleEvent() {
    //     //this.value = event.detail.value;
        
    // }
  
}