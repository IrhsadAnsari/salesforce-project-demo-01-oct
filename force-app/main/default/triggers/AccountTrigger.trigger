trigger AccountTrigger on Account (before insert,before delete,before update,after update, after insert) {
    public static Boolean isFistExecution = true;
    if(trigger.isBefore && trigger.isDelete)
    {
        //AccountHandler.validateAccount(trigger.old);
       // AccountHandler.restricAccountDeletion(trigger.Old);
    }
    if(trigger.isBefore && Trigger.isUpdate)
    {
      AccountHandler.returnNumberOfContactOnAccount(trigger.new);
    }
    if(trigger.IsAfter && Trigger.isUpdate)
    {
        AccountHandler.updateIsPhoneNumberOnContact(trigger.new, Trigger.Old);
    }
    if(Trigger.isBefore)
    {
        CommonHendler.checkAccountWithContactMap(trigger.isDelete, Trigger.old);
        AccountHandler.assignOwner(Trigger.isInsert, trigger.new);
    }
    if(Trigger.isAfter)
    {
         //if(isFistExecution){
         //isFistExecution = false;
        //AccountHandler.assignOwner(Trigger.isInsert , Trigger.new); 
         //}
       
    }
}