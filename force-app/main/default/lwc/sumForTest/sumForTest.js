import { LightningElement,api } from 'lwc';

export default class SumForTest extends LightningElement {
  @api  variable = 'hello'
    get sum() {
        const a = 4, b = 1;
        return (a+b)
    }
}