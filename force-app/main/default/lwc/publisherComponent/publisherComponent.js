import { LightningElement,wire } from 'lwc';
import sampleMessageChannel from '@salesforce/messageChannel/sampleMessageChannel__c';
import {publish,MessageContext} from 'lightning/messageService';
export default class PublisherComponent extends LightningElement {
datatosend;

@wire(MessageContext)
MessageContext;
changeHandler(event)
{
 this.datatosend = event.target.value;
}

publishHandler(event)
{
    console.log('Publishing the event');
 let message ={message : this. datatosend};
 console.log('Message to pass :'+JSON.stringify(message));
 publish(this.MessageContext,sampleMessageChannel,message);
}
}