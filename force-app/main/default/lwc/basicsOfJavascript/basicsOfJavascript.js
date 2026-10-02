import { LightningElement ,api} from 'lwc';
export default class BasicsOfJavascript extends LightningElement {
@api sumResult1
sumResult2
sumResult3
sumResult4
 connectedCallback() {
        this.sumResult1 = this.sum(10, 20); // Call the sum method here
        this.sumResult2 =this.sum2(20,40);
        this.sumResult3 = this.sum3(20,30);
        this.sumResult4 = this.sum4(20,90);

    }
sum(a,b)//type1 function declaration
{
  console.log(`sum of ${a} and ${b} is ${a+b}`);
  return a+b;
}
sum2= function(a,b) //type2 function expression
{
    console.log(`sum of ${a} and ${b} is ${a+b}`);
  return a+b;
}
// arrow function
sum3 =(a,b)=>{
    return a+b;
}
//arrow function modified above one
sum4 =(a,b)=> a+b;
/*
1.Function declaration and function expression.
2Argument not working with arrow function.
3.No protoype for arrow function.
4.new kwyword not working with arrow function.
5.Arrow function dont have Own this kyeyword */

}