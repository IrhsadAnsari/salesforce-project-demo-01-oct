import { LightningElement,track } from 'lwc';
export default class BmiCalculator extends LightningElement {
name='fist Component';
number1=5
number2=10
sum =0

@track address ={
    city:"Pune",
    pincode:841203
}

handelNameChange(event)
 {
    this.name =event.target.value;
 }
 handleAddressChange(event)
 {
    this.address.city=event.target.value;
 }
 handleNumberChange1(event)
 {
  this.number1 = parseInt(event.target.value);
 }
  handleNumberChange2(event) 
  {
   this.number2 = parseInt(event.target.value);
  }
  get sumgetters()
  {
    return this.number1 + this.number2;
  }
  sumHandler()
  {
       console.log('Button has been clicked');
    this.sum =this.number1+this.number2;
  }
  //bmi calculation property and logic
  height;
  weight;
  bmi;
  bmiCategory;
  handleWeightChange(event)
  {
   this.weight=parseFloat(event.target.value);
  }
  handleHieghtChange(event)
  {
   this.height=parseFloat(event.target.value);
  }
  calulateBmi()
  {
   if(this.weight > 0 && this.height > 0){
      const heightInMeters = this.height/100;
      const bmiValue = this.weight / (heightInMeters * heightInMeters);
      this.bmi = bmiValue.toFixed(2);
      this.bmiCategory =this.getBmiCategory(bmiValue)
   }else{
      this.bmi = null;
      this.bmiCategory = 'Please Enter valid weight and height !'
   }
  }
 getBmiCategory(bmi){
   if(bmi < 18.5) 
     return 'Under weight';
   if(bmi < 24.9)
     return 'Normal Weight';
   if(bmi < 29.9)
     return 'Overwieht';  
   return 'Obesity'
 }
}