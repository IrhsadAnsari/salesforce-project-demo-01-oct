import { LightningElement,api } from 'lwc';
import searchProducts from '@salesforce/apex/OpportunityHelper.searchProducts';
import updateContactOnOppty from '@salesforce/apex/OpportunityHelper.updateContactOnOppty';

const columns = [{ label: 'FirstName', fieldName: 'FirstName' },
           { label: 'Lastname', fieldName: 'lastName' }
          ];

export default class LineItemAddition extends LightningElement {
 @api recordId;    
searchKey;
contacts =[];
error =[];
optyList =[]
selectedContacts =[];
columns =columns;
   handleProductSearch(event)
    {
       this.searchKey =event.target.value;
       console.log('Search Contact'+JSON.stringify(this.searchKey));
        searchProducts({searchKey : this.searchKey}).then(result =>{
        this.contacts =result;
        console.log('Search Contact all'+JSON.stringify(this.contacts));
        }).catch(error =>{
        this.error =error
            });     
    } 
    handleRowSelection(event)
    {
      this.selectedContacts =event.detail.selectedRows;
      console.log('Selected reows'+JSON.stringify(this.selectedContacts));
    } 
    handleContactAddition()
    {
     this.optyList= this.selectedContacts.map(contact => ({
            Id: '006J3000005d2zjIAA',
            Contact_Name__c: contact.Id
            }));
           console.log('Opty with Contact Id'+JSON.stringify(this.optyList));
       updateContactOnOppty({ optylist: this.optyList })
            .then(() => {
                // Optionally show success message
                this.contacts = [];
                this.selectedContacts = [];
            })
            .catch(error => {
                console.error(error);
            });

    }
}