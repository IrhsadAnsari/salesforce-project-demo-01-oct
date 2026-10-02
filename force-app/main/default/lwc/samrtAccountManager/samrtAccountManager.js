import { LightningElement ,track} from 'lwc';
import searchAccounts from '@salesforce/apex/AccountController.getAccountLookUp';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const col =[
    {label : 'Account Name', fieldName : 'Name'},
    {label : 'Phone', fieldName : 'Phone'},
    {label : 'Industry', fieldName : 'Industry'},
    {label : 'Rating', fieldName : 'Rating'},
    ]

export default class SamrtAccountManager extends LightningElement {
    searchKey;
    @track accounts=[];
    columns = col;
    isloading = false;
    handleSearch(event){
        this.isloading = true;
        console.log('event keyword.'+event.detail);
        this.searchKey = event.detail;
        console.log('Searchkey.'+this.searchKey);
        searchAccounts({searchKey : this.searchKey}).then(result => {this.accounts=result}) 
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        })
        .finally(() => this.isloading = false);
    }

    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }

}