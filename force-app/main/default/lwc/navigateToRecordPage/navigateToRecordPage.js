import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
export default class NavigateToRecordPage extends NavigationMixin(LightningElement) {
    navigateToRecordEdit(){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:'0035i0000BjOD5BAQW',
                objectApiName:'Contact',
                actionName:'edit'
            }
        })
    }
    navigateToRecordView(){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                recordId:'0035i0000BjOD5BAQW',
                objectApiName:'Contact',
                actionName:'view'
            }
        })
    }
}