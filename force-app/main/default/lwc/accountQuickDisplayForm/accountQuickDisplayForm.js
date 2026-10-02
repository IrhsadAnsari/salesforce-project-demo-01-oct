import { LightningElement ,wire} from 'lwc';
import GETACCOUNTDETAILS from '@salesforce/apex/AccountController.getAccountDetails';
export default class AccountQuickDisplayForm extends LightningElement {

    enterName
    name
    type
    industry
    @wire(GETACCOUNTDETAILS, {accName:'$enterName' })
    accountRecord({data,error})    {
         if(data)
         {
            this.name=data.Name
            this.type=data.Type
            this.industry=data.Industry

         }
         if(error)
         {
            console.log('an error occured during fetching the record')
         }
    }

   /* get getOpportunity() {
        return this.opportunity.data;
    }*/
    AccountHandler(event){
        this.enterName=event.target.value;
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