trigger AccountTriggerHandler on Account (after update) {
 If(trigger.isUpdate)
 {
    List<Id> accountID =new List<Id>();
    System.debug('Trigger Exection Start');
    for(Account acc:trigger.new){
        
        Account oldAcc =Trigger.oldMap.get(acc.Id);
         if(acc.Phone != oldAcc.Phone)
         {
             accountID.add(acc.Id);
         }
    }
    FutureApex.futureCallout(accountID);
    System.debug('Trigger Exection end for callout'); 
   System.debug('Trigger Exection Start for callout2'); 
    FutureApex.futureCallout2(accountID);

   System.debug('Trigger Exection Start'); 
 }
    

}