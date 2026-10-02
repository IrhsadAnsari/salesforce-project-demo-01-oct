import { LightningElement } from 'lwc';
// Car__c schema
import NAME_FIELD from '@salesforce/schema/Car__c.Name';
import PICTUREURL_FIELD from '@salesforce/schema/Car__c.Picture_URL__c';
import CATEGORY_FIELD from '@salesforce/schema/Car__c.Category__c';
import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c';
import MSRP_FIELD from '@salesforce/schema/Car__c.MSRP__c';
import SEAT_FIELD from '@salesforce/schema/Car__c.Number_of_Seats__c';
import CONTOROL_FIELD from '@salesforce/schema/Car__c.Control__c';
import FUELTYPE_FIELD from '@salesforce/schema/Car__c.Fuel_Type__c';
import DESCRIPTION_FIELD from '@salesforce/schema/Car__c.Description__c';
//this function is used to extract filed values
import {getFieldValue} from 'lightning/uiRecordApi';
export default class CarCard extends LightningElement {
    //Exposing filed name to make them availbale in template
    categoryField=CATEGORY_FIELD;
    makeField=MAKE_FIELD;
    msrpField=MSRP_FIELD;
    seatFeild=SEAT_FIELD;
    fuelField=FUELTYPE_FIELD;
    controlField=CONTOROL_FIELD;

    //Id of car to diplary data
    recordId='a0MJ3000000cdHDMAY'
    //car field displayed with specific format
    carName
    carPictureUrl 
    handleRecordLoaded(event)
    {
        const {records} =event.detail
        const recordData =records[this.recordId]
        this.carName=getFieldValue(recordData,NAME_FIELD)
        this.carPictureUrl=getFieldValue(recordData,PICTUREURL_FIELD)
    } 
     
}