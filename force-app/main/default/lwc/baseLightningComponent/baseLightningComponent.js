import { LightningElement,api,track } from 'lwc';
import FIELDNAME from '@salesforce/schema/Account.Name';
import TYPE  from '@salesforce/schema/Account.Type';

export default class BaseLightningComponent extends LightningElement {
 @api recordId;
 @api objectApiName;
 nameField =FIELDNAME;
 type=TYPE;
 @track parentId = '';
 handleParentChange(event){
    this.parentId = event.detail.value;
 }


 
 
}