import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
export default class NavigateToAccountNewReocrd extends NavigationMixin(LightningElement) {
    navigateToAccountReocrd ()
    {
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
               objectApiName:'Account',
               actionName:'new'
            }
        })
    }

}