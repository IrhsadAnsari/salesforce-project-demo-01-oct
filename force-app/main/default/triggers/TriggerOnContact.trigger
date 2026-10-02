trigger TriggerOnContact on Contact (before insert,After insert,before update,after Update) {
  if(Trigger.isBefore)
  {
      System.debug('Before Trigger is exceuting....');
      ContactHelper.contactValidation(Trigger.isInsert, trigger.new);
      ContactHelper.validateAccountSelection(Trigger.isInsert , Trigger.new);
  }
 if(Trigger.isAfter)
 {
     System.debug('After trigger is executing...');
    // ContactHelper.createAccount(Trigger.isInsert, Trigger.new);
 }
}