import { LightningElement } from 'lwc';

export default class AccountSearch extends LightningElement {
    keyword = '';
    handlekey(event){
        this.keyword = event.detail.value;
    }
    
    handleSearch(){
        console.log('Keyword: ' + this.keyword);
        const searchEvent = new CustomEvent('search', {
            detail: this.keyword} );
        this.dispatchEvent(searchEvent);
    }
}