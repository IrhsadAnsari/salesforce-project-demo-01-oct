import { LightningElement ,track} from 'lwc';
export default class DemoParentComponent extends LightningElement {
    name;
age=20;
surname;
@track parentObj={
    name:'Irshad',
    age :24
}
nameChnageHandler(event)
{
    this.name= event.target.value;
}
surNameChangeHandler(event){
    this.surname = event.target.value;
    console.log('this.surname=='+this.surname);
    const childcomp= this.template.querySelector('c-demo-child-component');
    console.log('childcomp'+childcomp);
    childcomp.surnameChange(event.target.value);
}
}