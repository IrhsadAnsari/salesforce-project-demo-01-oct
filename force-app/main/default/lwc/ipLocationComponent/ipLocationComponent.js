import { LightningElement,api,track } from 'lwc';
import getIpCompleteLcoation from '@salesforce/apex/IPApi.ipCompleteLocation';
import getfetchLocationOfIpAddess from '@salesforce/apex/IPApi.fetchLocationOfIpAddess';


export default class IpLocationComponent extends LightningElement {
    @api ipAddress;
    @track locationData;
    @track mapMarkers=[];
    @track error;

    //variable for handleSearchLocation
    @track addressField;
    @api ipAddress1;
    @track responseField;

    handleAdressChnage(event){
        this.addressField = event.target.value;
    }
    handleIpChange1(event)
    {
      this.ipAddress1=event.target.value;  
    }

    handleIpChange(event)
    {
       this.ipAddress=event.target.value;
    }
    handleSearch()
    {
        if(this.ipAddress)
        {
            getIpCompleteLcoation({ipAddress:this.ipAddress})
             .then((data)=>{
                this.locationData=data;
                this.error=undefined;
                this.mapMarkers=[
                    {
                        location: {
                            Latitude: data.latitude,
                            Longitude: data.longitude
                        },
                        title: `Location of IP: ${data.ip}`,
                        description: `City: ${data.city}, Region: ${data.region}, Country: ${data.country_name}`
                    }
                ]
             })
             .cathc((error)=>{
                this.error=error;
                this.locationData = undefined;
                this.mapMarkers = [];
             })
        }
    }
    get mapCenter() {
        return this.mapMarkers.length > 0 ? this.mapMarkers[0].location : null;
    }
//method for handleSearchLocation
  handleSearchLocation()
  {
    if(this.ipAddress1 && this.addressField)
    {
        getfetchLocationOfIpAddess({ipAddress:this.ipAddress1,field:this.addressField})
        .then((data)=>{
             this.responseField=data;
             this.error=undefined;
        })
        .catch((error)=>{
            this.error=error;
            this.responseField=undefined
        })
    }
  }
}