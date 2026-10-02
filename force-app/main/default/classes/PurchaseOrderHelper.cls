public class PurchaseOrderHelper {
    public static void shipmentAutoCreation(Boolean isUpdate, List<Purchase_Order__c> purchaseRecord) {
        Set<Id> purchaseId = new Set<Id>();
        List<Self_Shipment__c> shipments = new List<Self_Shipment__c>();
        
        // Collect the Purchase Order Ids
        for(Purchase_Order__c po : purchaseRecord) {
            purchaseId.add(po.Id);
        }

        // Query related shipments
        Map<Id, Integer> poToShipmentCount = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT Purchase_Order__c, COUNT(Id) shipmentCount 
                                   FROM Self_Shipment__c 
                                   WHERE Purchase_Order__c IN :purchaseId 
                                   GROUP BY Purchase_Order__c]) {
            poToShipmentCount.put((Id) ar.get('Purchase_Order__c'), (Integer) ar.get('shipmentCount'));
        }
        
        // Loop through Purchase Orders and create shipments if none exist
        for(Purchase_Order__c po : purchaseRecord) {
            Integer shipmentCount = poToShipmentCount.get(po.Id);
            if (shipmentCount == null && po.Status__c == 'Shipped' && po.Is_Shipped__c == true) {
                shipments.add(new Self_Shipment__c(
                    Dealer_Account__c = po.DealerAccounts__c,
                    Purchase_Order__c = po.Id,
                    Suplier_Account__c = po.DealerAccounts__c
                ));
            }
        }
        
        System.debug('Shipments--->' + shipments);
        
        if(!shipments.isEmpty()) {
            try {
                insert shipments;
            } catch (DmlException e) {
                System.debug('DML Exception: ' + e.getMessage());
                // Handle exceptions as needed
            }
        }
    }
}