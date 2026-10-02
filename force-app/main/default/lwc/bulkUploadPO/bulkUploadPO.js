import { LightningElement } from 'lwc';
import getFieldSets from '@salesforce/apex/BulkImportController.getFieldSets';
import getFieldSetFields from '@salesforce/apex/BulkImportController.getFieldSetFields';
import importRecords from '@salesforce/apex/BulkImportController.importRecords';

export default class BulkUploadPO extends LightningElement {
    objectApiName = 'Purchase_Order__c';
    fieldSetName;
    fieldSetFields = [];
    records = [];
    fieldSetOptions = [];

      async connectedCallback() {
        try {
            const fs = await getFieldSets({ objectApiName: this.objectApiName });
            this.fieldSetOptions = (fs || []).map(f => ({ label: f, value: f }));
        } catch (e) {
            console.error(e);
        }
    }

    async handleFieldSetChange(event) {
        try {
            this.fieldSetName = event.detail.value;
            this.fieldSetFields = await getFieldSetFields({
                objectApiName: this.objectApiName,
                fieldSetName: this.fieldSetName
            });
        } catch (e) {
            console.error(e);
        }
    }

    downloadTemplate() {
        const header = this.fieldSetFields.map(f => f.apiName).join(',');
        const csv = header + '\n';
        const a = document.createElement('a');
        a.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
        a.download = 'Template.csv';
        a.click();
    }

    handleFile(event) {
        const file = event.target.files[0];
        const reader = new FileReader();
        reader.onload = () => this.parseCSV(reader.result);
        reader.readAsText(file);
    }

      parseCSV(data) {
        data = data.replace(/\ufeff/g, '').replace(/\r\n/g, '\n');
        const lines = data.split('\n').filter(l => l.trim());
        const headers = lines[0].split(',').map(h => h.trim());

        this.records = lines.slice(1).map(row => {
            const values = row.split(',');
            let obj = {};
            headers.forEach((h, i) => obj[h] = values[i]?.trim() || null);
            return obj;
        });

        console.log('Records:', this.records);
    }


    async handleImport() {
        if (!this.records.length) {
            alert('No records to import');
            return;
        }

        try {
            await importRecords({
                objectApiName: this.objectApiName,
                rows: this.records
            });
            alert('Import Successful');
        } catch (e) {
            alert(e?.body?.message || 'Import failed');
        }
    }

}