import { LightningElement } from 'lwc';

export default class ParentChildResetForm extends LightningElement {
  
    resetChildForm() {
        this.template.querySelector('c-child-reset-form').resetForm(); // Call the child's @api method
    }

}