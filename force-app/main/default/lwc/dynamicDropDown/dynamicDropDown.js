import { LightningElement,api} from 'lwc';

export default class DynamicDropDown extends LightningElement {
    @api objectApiName;

    value;
    get isdisabled() {
        console.log('objectApiName====',this.objectApiName)
        console.log('objectApiName disable ====',(this.objectApiName==='Account'))
        return (!(this.objectApiName==='Account'))
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