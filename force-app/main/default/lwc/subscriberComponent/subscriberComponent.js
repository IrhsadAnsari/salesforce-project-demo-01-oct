import { LightningElement,wire } from 'lwc';
import sampleMessageChannel from '@salesforce/messageChannel/sampleMessageChannel__c';
import {subscribe,MessageContext} from 'lightning/messageService'
export default class SubscriberComponent extends LightningElement {
dataReceived;
 @wire(MessageContext)
 MessageContext;
 connectedCallback() {
    
    this.handleSubscriber();
 }
 handleSubscriber()
{
    console.log('Subscirber is callled');
    this.subscription = subscribe(this.MessageContext, sampleMessageChannel,(message)=>{
        console.log('This is the message received: '+message.message);
        this.dataReceived=message.message;
    });
}

}