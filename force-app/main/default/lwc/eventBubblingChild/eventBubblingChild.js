import { LightningElement } from 'lwc';
export default class EventBubblingChild extends LightningElement {
    name;
nameChangeHandler(event)
{
    this.name= event.target.value;
    const myEvent = new CustomEvent('mycustomevent',{detail:this.name, bubbles:true,composed:true});
    this.dispatchEvent(myEvent);
}
}