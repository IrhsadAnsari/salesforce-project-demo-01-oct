import { LightningElement } from 'lwc';

export default class JavaScriptVarLetConst extends LightningElement {
    z= 40;
    //var z =10; not allowed in lwc
    //console.log(x);
        //let z =10; not allowed in lwc
    //const z =10; not allowed in lwc

    connectedCallback(){
        console.log(x);
        var x = 10;
        console.log(x)
        var x = 20;
        console.log(x)
        console.log(this.z);
        console.log(window);
        this.myFunction();
        this.myFunction1();
    }
    myFunction(){
        let x = 10;
        console.log(x);
        //let x = 20; Not allowd redelare
        x=30;  //re-assigend alloweds
        console.log(x);
        console.log(this.z);
        if(3===3){
            let y= 20;
            console.log(y);
        }
        //console.log(y);
    }

    myFunction1(){
        console.log('Constant keyword');
        const x = 10;
        console.log(x);
        //const  x = 20; Not allowd redelared
        // x=30;  //Not re-assigend alloweds
        console.log(x);
        console.log(this.z);
        if(3===3){
            let y= 50;
            console.log(y);
        }
        //console.log(y); not allowed because outside the Block calling
    }
    
  
}