import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
export default class NavigateToTab extends NavigationMixin(LightningElement) {
    navigateToTab() {
        this[NavigationMixin.Navigate]({
            type:'standard__navItemPage',
            attributes:{
                apiName:'Navigation'
            }
        })
    } 
    navigateToOpportunityTab() {
        // Navigate to the Opportunity tab
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'home'
            }
        });
    }  
}