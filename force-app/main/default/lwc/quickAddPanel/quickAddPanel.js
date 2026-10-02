import { LightningElement, track, wire, api } from 'lwc';
import getPriceLists from '@salesforce/apex/QuickAddItemPanelController.getPriceLists';
import getPriceListRule from '@salesforce/apex/QuickAddItemPanelController.getPriceListRule';
import getItems from '@salesforce/apex/QuickAddItemPanelController.getItems';
import PRODUCT_FIELD from '@salesforce/schema/Product2.Name'
import addItemToPurchaseOrder from '@salesforce/apex/QuickAddItemPanelController.addItemToPurchaseOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuickAddItemPanel extends LightningElement {
    @api recordId;  // Purchase Order ID
    @track priceListOptions = [];
    @track taxGroupOptions = [];
    @track itemOptions = [];
    @api quantity =1;
    @api cost;
    prductModel=PRODUCT_FIELD;

    
    selectedPriceList;
    //selectedTaxGroup;
    selectedProduct;

    @wire(getPriceLists)
    wiredPriceLists({ data, error }) {
        if (data) {
            this.priceListOptions = data.map(pl => ({ label: pl.Name, value: pl.Id }));
        } else if (error) {
            this.showToast('Error', 'Error loading Price Lists', 'error');
        }
    }
    @wire(getPriceListRule,{prodId : '$selectedProduct'})
     priceList({data,error})
     {
     if(data)
         {
            this.cost=data.Unit_Price__c;

         }
         else if(error)
         {
            console.error('an error occured during fetching the record');
            
         }

     }  

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

    handleItemChange(event) {
        this.selectedProduct = event.detail.value;
    }
    handleQuantityChange(event){
       this.quantity= event.target.value;
    }
    handleCostChange(event)
    {
        this.cost = event.target.value;
    } 

    handleAddItem() {
    if (this.selectedProduct && this.selectedPriceList && this.quantity > 0 && this.cost > 0) 
       { 
        addItemToPurchaseOrder({
            purchaseOrderId: this.recordId,
            prodId: this.selectedProduct,
            priceListId: this.selectedPriceList,
            quantity:this.quantity,
            unitCost:this.cost


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