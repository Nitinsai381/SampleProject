import { LightningElement , api} from 'lwc';

export default class ChildComponent extends LightningElement {
    // @api message; // This is exposed to the parent
    // get messageInfo() {
    //     return this.message ? `Message from Child : ${this.customer.phone}` : 'No message displayed';
    // }

    @api message;
    
    get messageInfo() {
        return this.message ? `Message from Child: ${this.message}` : 'No message';
    }
    @api onSubmit() {
        this.messageInfo();
    }
}