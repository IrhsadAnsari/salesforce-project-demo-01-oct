import { LightningElement,api } from 'lwc';
import recordValue  from '@salesforce/apex/GenericClass.recordValues'; 
import updateSelectedRecordWithCurrentRecordPageId from '@salesforce/apex/GenericClass.updateSelectedRecordWithCurrentRecordPageId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const col =[{label :'ID', fieldName : 'Id'},
      {label :'Name' ,fieldName :'Name'}
 ];
export default class RadioGroupDemo extends LightningElement {

@api recordId;
//@api objectApiName;
recordValues =[];
selectedValues ='';
error = [];
cols =col;
selectedRowRecords =[];
selectedObject ='';
listOfModifiedRecord =[];

options1 =[{label : 'Contact', value : 'Contact'},
     {label : 'Opportunity',  value : 'Opportunity'}]

options=[
    {label : 'Email', value :'Email'},
    {label : 'Phone', value : 'Phone'}
]

 
 changeHandler(event){
    this.selectedValues = event.detail.value;
    console.log('Selected VAlues: '+ JSON.stringify(this.selectedValues));
 }

 changeObjectHandler(event)
 {
    this.selectedObject = event.detail.value;
    console.log('Selected Object :'+JSON.stringify(this.selectedObject));
 }
 
 getRecord()
 {
    recordValue({objectName : this.selectedObject}).then(result=>{
        this.recordValues =result;
        console.log('Record Vallues :'+JSON.stringify(this.recordValues));
        this.error =[];
    }).catch(error =>{
        this.error = error;
        console.log('Error :'+ JSON.stringify(this.error));
        this.recordValues =[];
        this.showToast('Error', error.body?.message || 'Unknown error', 'error');
    });
 }

 handleRowSelection(event)
 {
    this.selectedRowRecords =event.detail.selectedRows;
    console.log('SelectedRecord :'+JSON.stringify(this.selectedRowRecords));
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

 get hasSelectedRecord()
 {
    return this.selectedRowRecords && this.selectedRowRecords.length >0;
 }

 updateHandler()
 {
    this.listOfModifiedRecord = this.selectedRowRecords.map(record=>({
        AccountId :this.recordId,
        Id : record.Id,
        Email :'irshad.ansari@gmail.com',
        Phone :'8340407854'
    }));
    console.log('Modified Contact record :'+ JSON.stringify(this.listOfModifiedRecord));
    updateSelectedRecordWithCurrentRecordPageId({listToUpdate : this.listOfModifiedRecord}).then(()=>{
        this.showToast('success', 'Record Has susccesfullay Updated!', 'success');
        this.selectedRowRecords =[];
        this.recordValues =[];
    }).catch(error=>{
        this.showToast('Error', error.body?.message || 'Unknown error', 'error');
        this.error =error;
    });
 }
}