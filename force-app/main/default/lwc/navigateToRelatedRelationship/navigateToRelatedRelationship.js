import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
export default class NavigateToRelatedRelationship extends NavigationMixin(LightningElement) {
    navigateToRelatedRecord(){
        this[NavigationMixin.Navigate]({
            type:'standard__recordRelationshipPage',
            attributes:{
                recordId:'0015i00000nSExDAAW',
                objectApiName:'Account',
                relationshipApiName:'Contacts',
                actionName:'view'
            }
        })
    }
}