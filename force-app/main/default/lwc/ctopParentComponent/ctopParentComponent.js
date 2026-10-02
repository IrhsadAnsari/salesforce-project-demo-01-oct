import { LightningElement } from 'lwc';
export default class CtopParentComponent extends LightningElement {
 dataReceived;
 namereceived;
parentEventHandler(event)
{
    this.dataReceived  =event.detail;
    console.log('Parent event handler has been triggered by child:'+ this.dataReceived);
}
nameChangeHnadler(event){
    this.namereceived =event.detail;
        console.log('Parent event handler has been eventBublling:'+ this.namereceived);

 }
}