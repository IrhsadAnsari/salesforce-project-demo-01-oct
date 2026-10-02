({
    calculate : function(component, event, helper) { 
		var fnumber=component.get("v.firstNumber"); 
        var snumber=component.get("v.secondnumber"); 
        component.set("v.result",fnumber+snumber);
    } 
})