trigger OpportunityTriggerHanler on Opportunity (before insert,before update,after insert, after update,before delete,after delete, after undelete) {
  if(trigger.isBefore)
  {
           
      if(trigger.isInsert)
      {
          System.debug('before Insert executing...');
      }
      if(trigger.isUpdate)
      {
          System.debug('before update executing...');
         // OpportunityHelper.opportunityAmountValidate(trigger.oldMap, trigger.newMap);
       //   OpportunityHelper.opportunityClosedDateToday(Trigger.oldMap , Trigger.newMap);
      }
       if(trigger.isDelete)
      {
          System.debug('before delete executing...');
      }
  }
   if(trigger.isAfter)
  {
     OpportunityHelper.inventoryDeduction(Trigger.isUpdate,Trigger.new);
      if(trigger.isInsert)
      {
          System.debug('after Insert executing...');
      }
      if(trigger.isUpdate)
      {
          System.debug('after update executing...');
      }
       if(trigger.isDelete)
      {
          System.debug('after delete executing...');
      }
      if(trigger.isUndelete)
      {
          System.debug('after undeleteis executing...');
      }
  }  
}