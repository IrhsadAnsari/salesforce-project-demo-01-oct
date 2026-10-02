({
	createAccountRec:function(component, event, helper) {
		var accName = component.find("accName").get("v.value");
        var accPhone = component.find("accPhone").get("v.value");
		var accRating = component.find("accRating").get("v.value");
		var accDate = component.find("accDate").get("v.value");
        console.log("accName::"+accName);
        console.log("accPhone::"+accPhone);
        console.log("accRating::"+accRating);
        var action = component.get("c.createAccountRecs");//getting controller method form apex
        
        action.setParams({
            "accountName":accName,
            "accountPhone":accPhone,
            "accountRating":accRating,
            "accountCreationDate":accDate
        });
        action.setCallback(this, function(response){
                          var state=response.getState();
                           if(state=="SUCCESS")
                           {
                               var accId=response.getReturnValue();
                              window.open("/"+accId);
                              // alert("Account record Created Successfully..."+JSON.stringify(accId));
                           }
            else{
                alert("Error Occured....");
            }
        });
        $A.enqueueAction(action);
     }
})