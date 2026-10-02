import { LightningElement, track, wire, api } from 'lwc';
import getPriceLists from '@salesforce/apex/QuickAddItemPanelController.getPriceLists';
import getPriceListRule2 from '@salesforce/apex/QuickAddItemPanelController.getPriceListRule2';
import getItems from '@salesforce/apex/QuickAddItemPanelController.getItems';
import poRecords from '@salesforce/apex/QuickAddItemPanelController.getPoRecords'
import addItemToPurchaseOrder from '@salesforce/apex/QuickAddItemPanelController.addItemToPurchaseOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuickAddItemPanel extends LightningElement {
    @api recordId;  // Purchase Order ID
    @track priceListOptions = [];
    @track taxGroupOptions = [];
    @track itemOptions = [];
    @api quantity =1;
    @api cost;

    @track selectedProduct;
    @track productDescription = '';
    @track unitCost = 0;
    
     @track selectedPriceListId
       selectedPriceList;
    //selectedTaxGroup;
    //selectedProduct;
    
    @wire(poRecords,{ recordId: '$recordId'})
     wiredRecord({data,error})
     {
        if(data)
        {
          this.selectedPriceListId =data.Price_List__c;
        }
        else{
        console.error('Error fetching price list: ', error);
           this.showToast('Error', 'Error loading Price Lists', 'error'); 
        }
     }
    
    @wire(getPriceLists)
    wiredPriceLists({ data, error }) {
        if (data) {
            this.priceListOptions = data.map(pl => ({ label: pl.Name, value: pl.Id }));
        } else if (error) {
            this.showToast('Error', 'Error loading Price Lists', 'error');
        }
    }
    handleProductSelect(event) {
        console.log('Custom event called.');
        this.selectedProduct = event.detail.product;
         console.log('selectedProduct--->' + JSON.stringify(this.selectedProduct));
        this.fetchPriceListRule();
        console.log('fetched Price list rule-->'+this.fetchPriceListRule());

    }
    fetchPriceListRule() {
        if (this.selectedProduct && this.selectedPriceListId) {
            getPriceListRule2({
                productId: this.selectedProduct.Id,
                priceListId: this.selectedPriceListId
            })
                .then((priceListRule) => {
                    this.productDescription = priceListRule.product__r.Description;
                    this.unitCost = priceListRule.Unit_Price__c;
                })
                .catch((error) => {
                    console.error('Error fetching price list rule: ', error);
                });
        }
    }
   /* @wire(getPriceListRule,{prodId : '$selectedProduct'})
     priceList({data,error})
     {
     if(data)
         {
            this.cost=data.Unit_Price__c;

         }
         else if(error)
         {
            console.log('an error occured during fetching the record');
            
         }

     } */



   /* @wire(getTaxGroups)
    wiredTaxGroups({ data, error }) {
        if (data) {
            this.taxGroupOptions = data.map(tg => ({ label: tg.Name, value: tg.Id }));
        } else if (error) {
            this.showToast('Error', 'Error loading Tax Groups', 'error');
        }
    }
*/
    @wire(getItems, { priceListId: '$selectedPriceList' })
    wiredItems({ data, error }) {
        if (data) {
            this.itemOptions = data.map(item => ({ label: item.Name, value: item.Id }));
        } else if (error) {
            this.showToast('Error', 'Error loading Items', 'error');
        }
    }

    handlePriceListChange(event) {
        this.selectedPriceList = event.detail.value;
    }

   /* handleTaxGroupChange(event) {
        this.selectedTaxGroup = event.detail.value;
    }*/

   /* handleItemChange(event) {
        this.selectedProduct = event.detail.value;
    }*/
    handleQuantityChange(event){
       this.quantity= event.target.value;
    }
    handleCostChange(event)
    {
        this.cost = event.target.value;
    } 

    handleAddItem() {
    if (this.selectedProduct && this.selectedPriceList && this.quantity > 0 && this.unitCost > 0) 
       { 
        addItemToPurchaseOrder({
            purchaseOrderId: this.recordId,
            prodId: this.selectedProduct,
            priceListId: this.selectedPriceList,
            quantity:this.quantity,
            unitCost:this.unitCost


           // taxGroupId: this.selectedTaxGroup
        })
        
        .then(() => {
            this.showToast('Success', 'Item added to Purchase Order', 'success');
            this.clearSelections();
        })
        .catch(error => {
            this.showToast('Error', 'Error adding item to Purchase Order', 'error');
        });
       }
       else{
        console.eror('Please fill all the Required fields');
        this.showToast('Error', 'Please fill all the required fields', 'error');

       } 
    }

    clearSelections() {
        this.selectedPriceList = null;
       // this.selectedTaxGroup = null;
        this.selectedProduct = null;
        this.quantity =null;
        this.cost = null;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}