import { LightningElement, track, api,wire } from 'lwc';
import searchProducts from '@salesforce/apex/ProductLookupController.searchProducts';
export default class ProddutLookup extends LightningElement {
    @track searchKey = '';
    @track products = [];
    @track productId;
    @api  selectedProduct;
    
    @track messageResult = false;
    @track showSearchedValues = false;

    @wire(searchProducts, { searchKey: '$searchKey' })
    retrieveProducts({ error, data }) {
        if (data) {
            this.products = data;
            this.showSearchedValues = data.length > 0;
            this.messageResult = data.length === 0 && this.searchKey !== '';
        } else if (error) {
            console.error(error);
        }
    }

    handleKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleParentSelection(event) {
        //this.productId = event.target.dataset.value;
        this.searchKey = event.target.dataset.label;
        const productids = event.currentTarget.dataset.productId;
        
        console.log('event.currentTarget.dataset--->' + JSON.stringify(event.currentTarget.dataset));
        console.log('productId--->' + JSON.stringify(this.productIds));

        this.selectedProduct = this.products.find(product => product.Id === productids);
    
       if (this.selectedProduct) {
          const selectEvent = new CustomEvent('productselect', {
                detail: { product: this.selectedProduct }
            });
           this.dispatchEvent(selectEvent);
         } else {
        console.error('Product not found.');
      }
        
        this.showSearchedValues = false;
    }
}