trigger GoodReceiptsTrigger on Good_Receipt__c (before insert,after insert) {
  GoodReceiptsHelper.goodReceiptLineCreation(trigger.isAfter ,Trigger.isInsert, trigger.new);
}