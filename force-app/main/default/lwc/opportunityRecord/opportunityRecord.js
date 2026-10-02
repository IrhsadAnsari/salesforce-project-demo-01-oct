import { LightningElement,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import opportunityNo from '@salesforce/apex/OpportunityBasedOnOptiNo2.opportunityNo';

export default class OpportunityRecord extends NavigationMixin(LightningElement) {
    enterOpportunity
    outputOpportunity
    opporrtuntyId
    @wire(opportunityNo, { opptyNo: '$enterOpportunity' })
    opportunityRecord({data,error})
    {
         if(data)
         {
            this.outputOpportunity=data.Name
            this.opporrtuntyId=data.Id

         }
         if(error)
         {
            console.log('an error occured during fetching the record')
         }
    }

   /* get getOpportunity() {
        return this.opportunity.data;
    }*/
    opportunityHandler(event){
        this.enterOpportunity=event.target.value;
    }
    navigateToRecordPage(event) {
        // Navigate to the opportunity record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.opporrtuntyId,
                objectApiName: 'Opportunity',
                actionName: 'view'
            }
        });
    }
}