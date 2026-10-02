trigger OpportunityTrigger on Opportunity (after insert,after update,after delete) {
if(Trigger.isAfter)
 {
    CommonHelper.rollUpOpportunity(Trigger.isInsert, Trigger.isUpdate,Trigger.isDelete, Trigger.new, Trigger.old);
 }
}