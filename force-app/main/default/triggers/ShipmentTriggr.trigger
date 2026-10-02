trigger ShipmentTriggr on Self_Shipment__c (before insert, after insert) {
    if(trigger.isBefore)
    {
        System.debug('Before tigger is exectuing.');
       //ShipmentHelper.shipmentLineCreation(trigger.isInsert, trigger.new);
    }
    if(trigger.isAfter)
    {
       ShipmentHelper.shipmentLineCreation(trigger.isInsert, trigger.new);
       ShipmentHelper.goodReceiptsAutoCreation(trigger.isUpdate,trigger.new); 
        System.debug('After trigger is execting');
    }
}