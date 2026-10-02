import { LightningElement,api,wire ,track} from 'lwc';
import postofficeApiByPincode from '@salesforce/apex/PostOfficeApi.postofficeApiByPincode';
import postofficeApiByBranchName from '@salesforce/apex/PostOfficeApi.postofficeApiByBranchName';

export default class PostalApiComponent extends LightningElement
 {
    @track pincode = '';
    @track branchName='';
    @track error;
    @track data = [];
    @track columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    {label:'PINCODE', fieldname:'PINCODE', type:'text'},
    { label: 'Description', fieldName: 'Description', type: 'text' },
    { label: 'BranchType', fieldName: 'BranchType', type: 'text' },
    { label: 'DeliveryStatus', fieldName: 'DeliveryStatus', type: 'text' },
    { label: 'Circle', fieldName: 'Circle', type: 'text' },
    { label: 'District', fieldName: 'District', type: 'text' },
    { label: 'Division', fieldName: 'Division', type: 'text' },
    { label: 'Region', fieldName: 'Region', type: 'text' },
    { label: 'State', fieldName: 'State', type: 'text' },
    { label: 'Country', fieldName: 'Country', type: 'text' }
];
/*wiredPincodeResult
  @wire(postofficeApiByPincode,{pincode:'$pincode'})
    getPostal({data,error})
    {
        this.wiredPincodeResult =data;
        if(data)
        {
            this.data =data.map(item => {
                return {
                    Name: item.Name,
                    Description: item.Description,
                    BranchType: item.BranchType,
                    DeliveryStatus: item.DeliveryStatus,
                    Circle: item.Circle,
                    District: item.District,
                    Division: item.Division,
                    Region: item.Region,
                    State: item.State,
                    Country: item.Country,
                };
            });
            this.error = undefined;
        }
        else if(error){
           console.error(error); 
           this.error = error;
           this.data = [];
        }
    }*/
    pincodeHandler(event)
    {
        this.pincode=event.target.value;
    }
    branchNameHandler(event)
    {
        this.branchName=event.target.value;
    }
   /* handleSearch() {
      refreshApex(this.wiredPincodeResult); 
    }*/
    //imperativ method
    handleSearch() {
        if (this.pincode) {
            postofficeApiByPincode({ pincode: this.pincode })
                .then((data) => {
                    this.data = data.map((item) => ({
                        Name: item.Name,
                        PINCODE: item.PINCODE,
                        Description: item.Description,
                        BranchType: item.BranchType,
                        DeliveryStatus: item.DeliveryStatus,
                        Circle: item.Circle,
                        District: item.District,
                        Division: item.Division,
                        Region: item.Region,
                        State: item.State,
                        Country: item.Country,
                    }));
                    this.error = undefined;
                })
                .catch((error) => {
                    this.error = error;
                    this.data = [];
                });
                this.pincode='';
        }
        else if(this.branchName)
            {
                postofficeApiByBranchName({ branchName: this.branchName })
                    .then((data) => {
                        this.data = data.map((item) => ({
                            Name: item.Name,
                            PINCODE: item.PINCODE,
                            Description: item.Description,
                            BranchType: item.BranchType,
                            DeliveryStatus: item.DeliveryStatus,
                            Circle: item.Circle,
                            District: item.District,
                            Division: item.Division,
                            Region: item.Region,
                            State: item.State,
                            Country: item.Country,
                        }));
                        this.error = undefined;
                    })
                    .catch((error) => {
                        this.error = error;
                        this.data = [];
                    });
                    this.branchName='';
            }  
    }
 }