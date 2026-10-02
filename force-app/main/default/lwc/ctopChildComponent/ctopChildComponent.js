import { LightningElement } from 'lwc';
export default class CtopChildComponent extends LightningElement {
name;
nameChangeHandler(event)
{
    this.name = event.target.value;
    const myEvent = new CustomEvent('childevent',{detail:this.name});
    this.dispatchEvent(myEvent);
}
}