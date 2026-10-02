import { LightningElement, api, wire } from 'lwc';
    import { ShowToastEvent } from 'lightning/platformShowToastEvent';
    import getFieldList from '@salesforce/apex/GenericClass.getFieldList';

    export default class GenericlineAdditionCmp extends LightningElement {
        @api recordId;
        @api objectApiName;
        @api fieldSetName;
        @api relationShipObjectName;
        @api title;
        fields;

        @wire(getFieldList, { objectName: '$relationShipObjectName', fieldSetName: '$fieldSetName' })
        getfields({ data, error }) {
            if (data) {
                this.fields = data;
            }   
            if (error) {
                console.error(error);
            }
        }

        handleSave() {
            const form = this.template.querySelector('lightning-record-edit-form');
            if (form) {
                form.submit();
                form.reset();
            }
        }

        handleSuccess(event) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record saved successfully!',
                    variant: 'success'
                })
            );
        }

        handleError(event) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error saving record',
                    message: event.detail.message,
                    variant: 'error'
                })
            );
        }
    }