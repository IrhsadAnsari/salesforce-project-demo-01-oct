import { LightningElement, api, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class LwcQuickAction extends LightningElement {
  @api recordId;
  error;
@wire(CurrentPageReference)
currentpage(currentPageReference){
              console.log('CurentPage',currentPageReference);

        if(currentPageReference){
          this.recordId=currentPageReference?.state?.recordId; 
        }
    }
  connectedCallback() {
    console.log('InsiedConnectedCallbackRecordId***'+this.recordId);
  }
  renderedCallback(){
    
    console.log('InsideRenderedCallbackRecordId***'+this.recordId);
  }
  disconnectedCallback() {
 
    console.log('InsideDisconnectedConnectedCallbackRecordId***'+this.recordId);
  }
  get dfe(){
    throw new Error('Invalid input provided')
  }
  errorCallback(error, stack) {
    this.error = error;
    console.log('Error**',this.error)
  }

  
}