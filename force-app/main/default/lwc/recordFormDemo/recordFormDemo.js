import { LightningElement,api } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ANNUAL_REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';


export default class RecordFormDemo extends NavigationMixin(LightningElement) {
    @api recordId
    @api objectApiName
    objectName=ACCOUNT_OBJECT
    fieldList=[NAME_FIELD,ANNUAL_REVENUE_FIELD,TYPE_FIELD,INDUSTRY_FIELD]
    successHandler(event)
    {
        console.log(event.detail.id)
        const toastEvent= new ShowToastEvent({
            title:"Account Created",
            message:"Record ID: "+event.detail.id,
            variant:'sucsess'
        })
        this.dispatchEvent(toastEvent)
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                //recordId:'$recordId',
                objectApiName:'Account',
                actionName:'home'
            }
        })
    }
}