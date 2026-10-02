import { LightningElement, wire } from 'lwc';
import getCar from '@salesforce/apex/CarControler.getCars'

export default class CarTile extends LightningElement {
cars
error
@wire(getCar)
carsHandeler({data,erro})
{
  if(data){
    console.log('data return'+data);
    this.casrs=data
  }
  else if(error)
  {
    this.error=this.error
    console.error(error);
  }
}
}