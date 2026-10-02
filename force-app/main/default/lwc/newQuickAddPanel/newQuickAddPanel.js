import { LightningElement ,api, wire,track} from 'lwc';
import getFieldSetField from '@salesforce/apex/CommonHendler.getFieldSetField';
export default class NewQuickAddPanel extends LightningElement {
@api objectName;
@api fieldSetName;
@api relationShipFieldName;
@api recordId;

fields =[];
error ='';
@track fieldValues ={};

  @wire(getFieldSetField, {objectName : '$objectName' , fieldSetName : '$fieldSetName'})
  wireFields({data, error}){
    if(data){
        this.fields = data;
        console.log('Fields:'+ JSON.stringify(this.fields));
        this.error ='';
    }else{
        this.error=error;
        console.log('Error :'+JSON.stringify(this.error));
        this.fields =[];
    }
  }


 
  /*getFieldValue(apiName) {
    return this.fieldValues[apiName] || '';
  }

  handleInputChange(event){
    const {name , value} =event.target;
    this.fieldValues[name] =value;
  }*/
}