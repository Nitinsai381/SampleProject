import { LightningElement } from 'lwc';

export default class ButtonForTestCase extends LightningElement {
    value;
    handleClick(event) {
        this.value = event.target.value;
    }
}