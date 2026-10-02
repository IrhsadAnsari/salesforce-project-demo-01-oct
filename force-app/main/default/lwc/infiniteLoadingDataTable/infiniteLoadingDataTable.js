import { LightningElement ,track} from 'lwc';
import getAccountInfinite from '@salesforce/apex/AccountController.getAccountsInfinite';

const COLUMN =[{ label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }];

export default class InfiniteLoadingDataTable extends LightningElement {
 columns =COLUMN;
  @track dataList=[];
 searchTerm='';

 limitSize=10;
 offset =0;

 infiniteLoading=true;
 delayTimeout;
 connectedCallback(){
        this.loadData(false);
 }

 loadData(appendData =false){
    getAccountInfinite({searchTerm: this.searchTerm, 
            limitSize: this.limitSize, 
            offset: this.offset 
        }).then(result =>{
        if(appendData){
          this.dataList=[...this.dataList,...result];
        }
        else{
          this.dataList=result;
        }
    }).catch(error =>{
        console.log('Error while fetching data');
        infiniteLoading =false;
    });
 }

 handleLoadMore(event){
    const targetTable=event.target;
    this.offset +=this.limitSize;
    targetTable.isLoading=true;
    this.loadData(true).then(()=>{
        targetTable.isLoading=false;
    }).catch(()=>{
       console.log('catch block');
    });
 }

 handleSearchChange(event){
    this.searchTerm = event.target.value;
    clearTimeout(this.delayTimeout);
    this.delayTimeout = setTimeout(()=>{
        this.offset=0;
        this.loadData(false);
    },200);
 }
}