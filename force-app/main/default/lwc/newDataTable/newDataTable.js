import { LightningElement } from 'lwc';
import getAccountRecord  from '@salesforce/apex/AccountController.getAccountRecord';
import getAccountRecords  from '@salesforce/apex/AccountController.getAccountRecords';

import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
const actions = [{label:'edit',name:'edit'},
                {label:'view',name:'view'},
                {label:'delete',name:'delete'},
                {label:'clone',name:'clone'}
                ]
const COLUMN =[{label:'Name', fieldName:'Name',editable:true},
              {label:'Rating', fieldName:'Rating'},
              {label:'Phone', fieldName:'Phone',editable:true},
              {label:'Industry', fieldName:'Industry'},
              {type :'action',typeAttributes:{rowActions:actions,menuAlignment:'right'}}];
export default class NewDataTable extends NavigationMixin(LightningElement) {
    dataList;
    columns=COLUMN;
    name='';
    selectedRows= [];
    draftValues=[];
    isLoading =false;
    pageSize =10;
    pageNumber =1;
    isNextDisabled;
    connectedCallback() {
        this.handleSearch();
    }
    handleNameChange(event){
        this.name = event.target.value;
        cosnole.log('Search value:'+this.name);
       // this.handleSearch();// this will cause a every input as server call and it can be avoid by debouncing technique
    }
    handleSearch(){
        this.isLoading = true
        getAccountRecord({searchKey:this.name})
        .then(result=>{
            this.dataList = result;
            console.log('Result of new datatabe :'+JSON.stringify(result));
        })
        .catch(error=>{
            this.error=error.body.message;
        })
        .finally(()=>{this.isLoading=false});
    }
    handleRowSelection(event){
        this.selectedRows = event.detail.selectedRows;
        console.log('Selected Rows: ' + JSON.stringify(this.selectedRows));
    }
    handleSave(event){
        alert('Save button clicked');
        this.draftValues = event.detail.draftValues;
        console.log('Draft values:', JSON.stringify(this.draftValues));
        //const updatedRows =event.detail.draftValues;

    updateAccounts({
        accountsJson:
            JSON.stringify(this.draftValues)
    })
    .then(() => {

        this.draftValues = [];

    })
    .catch(error => {

        console.error(error);

    });
    }
    
    handleRowAction(event){
        const action = event.detail.action.name;
        const rowId = event.detail.row.Id;
        console.log('Row Id: '+rowId);
        if(action === 'delete'){
            console.log('Action name : '+action);
            this.deleteRecord(rowId);
        }
        if(action === 'edit'){
            console.log('Action name : '+action);
            console.log('Row Id In edit: '+rowId);
            this.editRecord(rowId);
        }
        if(action === 'view'){
            console.log('Action name : '+action);
            console.log('Row Id In view: '+rowId);
            this.viewRecord(rowId);
        }
    }
    viewRecord(rowId){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
               recordId:rowId,
               objectApiName:'Account',
                actionName:'view'
            }
        });
    }

    editRecord(rowId){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
               recordId:rowId,
               objectApiName:'Account',
                actionName:'edit'
            }
        });
    }
    deleteRecord(rowId){
        deleteRecord(rowId).then(()=>{
            //this.dataList = this.dataList.filter( row => row.Id !== rowId);// if one row deleted then filter the retrived data table and minimize the table.
            this.handleSearch(); // if one record delete refresh whole table
            this.showToast('Success','Record Deleted Successfully','success');
        })
        .catch(error =>{
            this.showToast('Error Deleting record',error.body.message,'error');
        });
    }
    showToast(title,message,variant){
        this.dispatchEvent(new ShowToastEvent({title:title,
                                               message:message,
                                               variant:variant
                                               })
                                               );
    }

    //
    loadAccounts(){
        this.isLoading = true
        let offsetValue = (this.pageNumber - 1) * this.pageSize;
        getAccountRecords({pageSize:this.pageSize, offset:offsetValue })
        .then(result=>{
            this.dataList = result;
            this.isNextDisabled = result.length < this.pageSize;
            console.log('Result of new datatabe :'+JSON.stringify(result));
        })
        .catch(error=>{
            this.error=error.body.message;
        })
        .finally(()=>{this.isLoading=false});
    }
    handleNext(){
        this.pageNumber++;
        this.loadAccounts();
    }
   
    handleBack(){
        if(this.pageNumber < 0){
            return;
        }
        this.pageNumber--;
        this.loadAccounts()
    }

    get isBackDisabled(){
        return this.pageNumber <= 1;
    }
    
}