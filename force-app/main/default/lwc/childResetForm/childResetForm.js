import { LightningElement,api } from 'lwc';

export default class ChildResetForm extends LightningElement {
    name = '';
    email = '';
    @api resetForm() { // Exposed method
        this.name = '';
        this.email = '';
    }
    handleNameChange(event) {
        this.name = event.target.value;
    }
    handleEmailChange(event) {
        this.email = event.target.value;
    }
}