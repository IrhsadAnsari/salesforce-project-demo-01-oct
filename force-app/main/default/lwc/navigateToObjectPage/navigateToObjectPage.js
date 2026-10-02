import { LightningElement } from 'lwc';
import {encodeDefaultFieldValues} from 'lightning/pageReferenceUtils'
import {NavigationMixin} from 'lightning/navigation';

export default class NavigateToObjectPage extends NavigationMixin(LightningElement) {
    navigateToNewRecord(){ 
        this[NavigationMixin.Navigate]({ 
            type:'standard__objectPage',
            attributes:{ 
                objectApiName:'Contact',
                actionName:'new'
            }
        })
    }

    navigateToNewRecordWithDefaultValues(){ 
          const defaultValue=encodeDefaultFieldValues({
            FirstName:'Zero',
            LastName:'Hero'
        })
        this[NavigationMixin.Navigate]({ 
            type:'standard__objectPage',
            attributes:{ 
                objectApiName:'Contact',
                actionName:'new'
            },
            state:{
                defaultFieldValues: defaultValue
            }
        })
    }

    navigateToListView(){ 
        this[NavigationMixin.Navigate]({ 
            type:'standard__objectPage',
            attributes:{ 
                objectApiName:'Contact',
                actionName:'list'
            },
            state:{
                filterName:'Recent'
            }
        })
    }

  navigateToFiles(){ 
        this[NavigationMixin.Navigate]({ 
            type:'standard__objectPage',
            attributes:{ 
                objectApiName:'ContentDocument',
                actionName:'home'
            } 
        })
    }


}