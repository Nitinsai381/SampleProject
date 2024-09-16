import { LightningElement,api } from 'lwc';

export default class Demo extends LightningElement {

    @api message = 'jagadeesh';
    @api recordId;
}