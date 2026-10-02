import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/errorUtils';
/* https://developer.salesforce.com/docs/platform/lwc/guide/reference-lightning-ui-api-record.html */
export default class RecordFormWizard extends LightningElement {
accountName='';
creationDate;
phone='8340407854'
accountId
currentStep='1'
firstName
lastName
contactId
email
errorMessage
handleChange(event){
    const fieldName = event.target.dataset.id;
    const fieldValue = event.target.value;
    if(fieldName){
        this[fieldName] = fieldValue;
    }
   
}

createAccount(){
    console.log('Name===>', this.accountName)
    console.log('Phone===>', this.phone)
    console.log('AccountCreationDate===>', this.creationDate)

    const fields ={
        Name : this.accountName,
        Phone : this.phone,
        Account_Creation_date__c : this.creationDate
    }
    createRecord({apiName: 'Account',fields}).then(result =>  {this.accountId = result.id;
    console.log('AccountRecord Successfull Created',result);
    this.showToast('Record Created','Record created Successfully :'+this.accountId,'success');
    this.currentStep='2';
   /* this.accountName=''
    this.phone=undefined
    this.creationDate=undefined*/

  }).catch((error)=>{
    this.showToast('Error While Creation',error?.body?.message,'error');
  })
  } 


  createContact(){
    console.log('Name===>', this.accountName)
    console.log('Phone===>', this.phone)
    console.log('AccountCreationDate===>', this.creationDate)
    console.log('First Name===>', this.firstName)
    console.log('First Name===>', this.lastName)


    const fields ={
        FirstName : this.firstName,
        LastName : this.lastName,
        AccountId: this.accountId,
        Phone : this.phone,
        Email : this.email
    }
    createRecord({apiName: 'Contact',fields}).then(result =>  {this.contactId = result.id;
    this.showToast('Record Created','Record created Successfully :'+this.contactId,'success');
    this.currentStep='2';
   /* this.accountName=undefined
    this.phone=undefined
    this.creationDate=undefined*/

  }).catch((error)=>{

    console.log('Error',error);
     this.errorMessage = reduceErrors(error);
     console.log('ErrorMessageCustom:==>',this.errorMessage),
    this.showToast('Error While Creation',this.errorMessage,'error');

  })
  } 

  showToast(title,message,variant){
    this.dispatchEvent(new ShowToastEvent({
        title:title,
        message:message,
        variant:variant
    }))
  }

  get isAccount(){
    return this.currentStep === '1';
  }

  get isContact(){
    return this.currentStep === '2';
  }
}