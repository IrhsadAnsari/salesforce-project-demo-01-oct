trigger My_AccountTrigger on Account (before insert,before delete,After insert,before update,after update) {
     if(trigger.isAfter)
     {
        // My_AccountHandler.duplicacyAccountCheck(Trigger.isInsert,trigger.new);
              My_AccountHandler.checkPhoneIsValid(Trigger.isInsert,Trigger.new);

         if(trigger.isInsert)
         {
             
             System.debug('This is after trigger');
           // My_AccountHandler.accountToAssociatedContact(trigger.new);
           //My_AccountHandler.accountAndContactwithLastName(trigger.new);   
             //My_AccountHandler.contactEqualNumberOfLocationsOnAccount(trigger.new);
         }
         if(Trigger.isUpdate){
            My_AccountHandler.sentAccountToTrailHeadOrg(Trigger.new,Trigger.oldMap); 
         }
         
     }
    if(Trigger.isBefore)
    {   
       /* My_AccountHandler.checkIndustryFieldAndSetRating(trigger.isInsert, trigger.New);
        My_AccountHandler.upadteContactPhoneNumber(trigger.isInsert,trigger.isUpdate, Trigger.New);
        if(Trigger.isDelete)
        {
           //My_AccountHandler.validateOpportunityWithAccount(Trigger.old);
          My_AccountHandler.validateAccountContact(Trigger.oldMap);
        }
        My_AccountHandler.duplicacyAccountCheck(Trigger.isInsert,Trigger.isUpdate, trigger.new);
        System.debug('Account before updating billing address');
        My_AccountHandler.billingAddressToShippingAddress(Trigger.isInsert,Trigger.isUpdate ,Trigger.new);
        System.debug('Account after updating shipping address');*/


    }
}