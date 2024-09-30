import { LightningElement } from 'lwc';

export default class ParentChildDemo extends LightningElement {
    message = '';
    handleMessage(event) {
        this.message = event.target.value;
    }

}