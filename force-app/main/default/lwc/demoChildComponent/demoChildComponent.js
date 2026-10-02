import { LightningElement ,api} from 'lwc';
export default class DemoChildComponent extends LightningElement {
 @api name;
 @api age;
 @api childObj;
 surname;
 
connectedCallback() {
        // This will run when the component is inserted into the DOM
       console.log('ChildObj: ' + JSON.stringify(this.childObj));
    }

@api surnameChange(surname)
{
    console.log('child method is called');
    this.surname = surname;
    console.log('this.surname++'+this.surname);
    
}
}