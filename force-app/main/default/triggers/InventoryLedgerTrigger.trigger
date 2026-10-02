trigger InventoryLedgerTrigger on Inventory_Ledger__c (before insert,before update,after insert, After update) {
  InventoryLedgerHelper.stockPosting(trigger.isAfter, trigger.isUpdate,trigger.isInsert, trigger.New);
}