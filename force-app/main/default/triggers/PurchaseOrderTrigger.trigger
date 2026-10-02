trigger PurchaseOrderTrigger on Purchase_Order__c (before insert,after update,before update) {
  if(trigger.isBefore)
  {
      System.debug('Before trigger is executing');
  }
  if(trigger.isAfter)
  {
      PurchaseOrderHelper.shipmentAutoCreation(trigger.isUpdate, trigger.new);
      System.debug('After trigger is executing');
  }
  
}