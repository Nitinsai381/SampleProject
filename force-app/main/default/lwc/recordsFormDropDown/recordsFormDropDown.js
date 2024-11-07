import { LightningElement } from 'lwc';

export default class RecordsFormDropDown extends LightningElement {

    value;

    get options() {
        return [{ label: 'Account', value: 'Account' }, { label: 'Contact', value: 'Contact' }, { label: 'Opportunity', value: 'Opportunity' }];
    }
    handleChange(event) {
        this.value = event.detail.value;
        const selected = new CustomEvent('selectobject', { detail:{'value':this.value}  });
        this.dispatchEvent(selected)
        console.log('Child DropDown clicked value ==== ',this.value)
    }
}