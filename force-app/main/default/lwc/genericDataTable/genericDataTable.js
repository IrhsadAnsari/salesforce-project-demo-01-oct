import { LightningElement, api, wire } from "lwc";
import getFields from "@salesforce/apex/GenericClass.getFieldList";
import getRecords from "@salesforce/apex/GenericClass.getRecords";

export default class GenericDataTable extends LightningElement {
  @api recordId;
  @api relationShipObjectName;
  @api fieldSetName;
  @api title;
  columns = [];
  dataList = [];
  data = [];
  error;

  @wire(getFields, {
    objectName: "$relationShipObjectName",
    fieldSetName: "$fieldSetName",
  })
  fieldResult({ data, error }) {
    if (data) {
      this.data = data;
      this.columns = data.map((field) => {
        return {
          label: field.label,
          fieldName: field.fieldApiName,
        };
        console.log("Columns results :" + JSON.stringify(this.columns));
      });
      this.error = undefined;
    }
    if (error) {
      this.error = error.body.message;
    }
  }

  @wire(getRecords, {
    bjectName: "$relationShipObjectName",
    fieldSetName: "$fieldSetName",
  })
  getRecords({ data, error }) {
    if (data) {
      this.dataList = data;
      this.error = undefined;
      console.log("Data results :" + JSON.stringify(this.dataList));
    }
    if (error) {
      this.dataList = undefined;
      this.error = error.body.message;
    }
  }
}