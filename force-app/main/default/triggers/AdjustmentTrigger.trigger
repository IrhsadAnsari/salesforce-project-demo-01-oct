trigger AdjustmentTrigger on Adjustment__c (before insert,before update,after insert,after update) {
  if(Trigger.IsAfter)
  {
      if(Trigger.isUpdate)
      {
          AdjustmentHelper.inventoryPosting(Trigger.new,trigger.oldMap);
      }
  }
}