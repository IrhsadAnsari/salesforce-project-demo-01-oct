import { LightningElement ,wire,track} from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import   getAccountList2 from '@salesforce/apex/AccountController.getAccountList2'
import   getAccount from '@salesforce/apex/AccountController.getAccount'

import ACCOUNT_OBJECT from '@salesforce/schema/Account';

const columns=[
    {label:'Name', fieldName:'Name'},
    {label:'Industry', fieldName:'Industry'},
    {label:'Phone', fieldName:'Phone'}
   ];
export default class DataTable extends LightningElement {
  @track data = [];
  dataList = [];
  offsetValue=0;
 @track column = columns;
 //resultLWC= [];
//Calling Apex method by Wire functions
@wire(getAccountList2)
 getAccounts({error,data})
   { 
    if (data) {
            this.data = data;
            console.log('this log'+ JSON.stringify(this.data ));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    }

    //Calling Apex method by Imperative way
    fetchAccount()
    {
        getAccount({offsetValue :this.offsetValue}).then(result=>{
            this.dataList= result;
                        console.log('Data :'+JSON.stringify(this.dataList));
            this.error = undefined;
        }).catch(error =>{
            this.error = error;
            console.log('Error :'+JSON.stringify(this.error));
            this.dataList = undefined;
        });
         
    }

    handleClick()
    {
        this.fetchAccount();
    }
    increaseOffset()
    {
        this.offsetValue = this.offsetValue + 10;
        console.log('Offset value :'+this.offsetValue);
        this.fetchAccount();
    }
    decreaseOffset()
    {
        if (this.offsetValue - 10 < 0) {
            alert('Offset cannot be negative.');
        } 
       else {
        this.offsetValue =this.offsetValue - 10;        
        console.log('Offset value :'+this.offsetValue);
        this.fetchAccounts();
        }  
    }

    
downloadCSV() {
        let csvContent = "data:text/csv;charset=utf-8,";
        csvContent += this.column.map(col => col.label).join(",") + "\n";
        this.dataList.forEach(account => {
            let row = this.column.map(col => account[col.fieldName]).join(",");
            csvContent += row + "\n";
        });

        const encodedUri = encodeURI(csvContent);
        const link = document.createElement("a");
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", "accounts.csv");
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    
}