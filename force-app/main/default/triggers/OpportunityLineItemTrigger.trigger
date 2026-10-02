trigger OpportunityLineItemTrigger on OpportunityLineItem(after insert, after update, after delete) {
 if(Trigger.isAfter)
 {
    CommonHelper.rollUpOpportunityLineItem(Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.new, Trigger.old);
 }
}