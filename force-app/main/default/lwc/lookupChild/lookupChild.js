import { LightningElement ,track,api} from 'lwc';
import getAccountLookUp from '@salesforce/apex/AccountController.getAccountLookUp';
import saveContact from '@salesforce/apex/AccountController.saveContact';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from "lightning/actions";

export default class LookupChild extends LightningElement {

    @api objectApiName;
    @api recordId;
    @api fields;
    @api title = 'Record List';
    @track searchKey;
    @track data =[];
    @track selectedRecord ;
    fieldName = 'Name';
    showDropdown =false;
    error =[];
    @track recordItem ='';

    model=true;
    fistNameValue;
    lastNameValue;
    email;
    phone;

    typingTimer =0;
    doneTypingInterval=500;
    
    handleSearch(event)
    {
        this.searchKey = event.target.value;
        if(this.searchKey.length > 0){
             getAccountLookUp({searchKey : this.searchKey}).then(result=>{
                this.data = result;
                this.showDropdown = true;
                console.log('Data is:'+ JSON.stringify(this.data));
                this.error =undefined;
            }).catch(error=>{
                this.error =error;
                this.showDropdown =false;
                this.data = [];
            });
        }else
        {
            this.data =[];
            return;
        }
    }

    handleSelect(event)
    {
      const recordId =  event.currentTarget.dataset.id;
      console.log(' record Id:'+ recordId);
      const recordName  =event.currentTarget.dataset.name;
      console.log(' record Name:'+ recordName);
      this.searchKey = recordName;
      this.selectedRecord ={Id :recordId,Name:recordName};
      console.log('Selected record'+JSON.stringify(this.selectedRecord));
      this.showDropdown =false;
      consol.log('dropDown values:'+this.showDropdown);
      const customeEvent = new CustomEvent('recordselected',{detail:this.selectedRecord})
      this.dispatchEvent(customeEvent);
    }
  

    firstNameChaneHandler(event)
    {
        clearTimeout(this.typingTimer);//clear previous timout.
      const value = event.target.value;
        this.typingTimer = setTimeout(()=>{
           this.fistNameValue = value;
           console.log(`FirstName  is:  ${this.fistNameValue}`);
        },1000);
    }

    lastNameChaneHandler(event){
        this.lastNameValue = event.target.value;
        console.log(`LastName is :  ${this.lastNameValue} `);
    }

    emailChaneHandler(event){
        this.email = event.target.value;
        console.log(`Email is:  ${this.email} `);
    }

    phoneChaneHandler(event){
        this.phone = event.target.value;
        console.log(` phone is: ${this.phone}`);
    }

    cancelHandler()
    {
        this.searchKey ='';
        this.fistNameValue ='';
        this.lastNameValue ='';
        this.email ='';
        this.phone ='';
        this.closePanel();
    }

    saveHnadler()
    {
         this.recordItem ={
            AccountId : this.selectedRecord.Id,
            FirstName : this.fistNameValue,
            LastName : this.lastNameValue,
            Email : this.email,
            Phone : this.phone

        };
        console.log('Record To insert :'+JSON.stringify(this.recordItem));
         saveContact({contactToInsert : this.recordItem}).then(()=>{
                this.searchKey ='';
                this.fistNameValue ='';
                this.lastNameValue ='';
                this.email ='';
                this.phone ='';
                this.showToast('success', 'Record Has susccesfullay Inserted!', 'success');
         }).catch(error =>{
            this.error =error;
            this.recordItem ='';
            this.showToast('error',error.body?.message ||'Unkonown error','error')
         });
         this.closePanel();

    }

showToast(title,message,variant)
 {
    this.dispatchEvent(
        new ShowToastEvent({
            title : title,
            message :message,
            variant :variant}
        )
    );
 }

 closePanel(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleRefresh(){
        alert('Refreshed Clicked!');
    }

}