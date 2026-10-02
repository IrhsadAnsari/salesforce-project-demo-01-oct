trigger ContactTrigger on Contact (before insert,before update, after update,after insert,after delete, After undelete) {
 if(Trigger.IsAfter)
 {
    //ContactHandler.returnNumberOfContactOnParent(Trigger.isUpdate ,Trigger.New);
    CommonHendler.numberofContactOnAccount(trigger.isInsert, trigger.isUpdate, trigger.isUndelete,trigger.isDelete,
    Trigger.new,Trigger.old);
 }
 if(Trigger.isBefore)
 {
   // ContactHandler.checkContactEmail(Trigger.isInsert ,Trigger.isUpdate , Trigger.new);
 }
}