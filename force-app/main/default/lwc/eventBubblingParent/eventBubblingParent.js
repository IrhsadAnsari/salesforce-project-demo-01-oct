import { LightningElement } from 'lwc';
export default class EventBubblingParent extends LightningElement {
dataReceived
/*constructor()
  {
    super();
    this.template.addEventListener('mycustomevent', this.handleCustomEvent.bind(this));
  }*/
  handleCustomEvent(event)
  {
    this.dataReceived = event.detail;
  }


}