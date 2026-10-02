public class ShipmentHelper {
  public static void shipmentLineCreation(Boolean isInsert, List<Self_Shipment__c> shipents)
  {
     // List<ID> shipmentId = (List<ID>)RecordHelper.extractIds(shipents);
     // List<Id> shipmentId = new List<Id>();
      Set<Id> purchaseId = new Set<Id>();
      for(Self_Shipment__c ship:shipents)
      {
          //shipmentId.add(ship.Id);
         purchaseId.add(ship.Purchase_Order__c);
      }
       System.debug('PurchaseId--->'+purchaseId);

      List<Purchase_Order_Line__c> polines = [select ID, Name, Price_List__c,Product__c,Qunatity__c,Unit_Cost__c,Amount__c,
                                            Purchase_Order__c from Purchase_Order_Line__c where Purchase_Order__c In: purchaseId];
      System.debug('Purchase_Order_Line__c--->'+polines);
      List<Shipment_Line_Item__c> shipmentlines = new List<Shipment_Line_Item__c>();
      for(Purchase_Order_Line__c pline:polines)
      {
          Shipment_Line_Item__c shipmentline = new Shipment_Line_Item__c();
          for(Self_Shipment__c shipment :shipents)
          {
          shipmentline.Shipment__c = shipment.Id;
          shipmentline.Purchase_Order_Line__c = pline.Id;
          shipmentline.Product__c =pline.Product__c;
          shipmentline.Quantity__c= pline.Qunatity__c;
          shipmentline.Invoice_quantity__c =pline.Qunatity__c;
          shipmentline.Ordered_Quanity__c = pline.Qunatity__c;
          shipmentline.Unit_Price__c = pline.Unit_Cost__c;
          } 
         shipmentlines.add(shipmentline); 
      }
      System.debug('Shipment lines ---> '+shipmentLines);
      if(!shipmentlines.isEmpty())
      {
          insert shipmentlines;
      }
      System.debug('Shipment line successfully created');  
  }
    //Good Recept auto creation
    public static void goodReceiptsAutoCreation(Boolean isUpdate, List<Self_Shipment__c> shipmentRecord) {
        Set<Id> shipmentId = new Set<Id>();
        List<Good_Receipt__c> goodReceipts = new List<Good_Receipt__c>();
        
        // Collect the shipment Order Ids
        for(Self_Shipment__c so : shipmentRecord) {
            shipmentId.add(so.Id);
        }

        // Query related Good Receipt
        Map<Id, Integer> soToGoodReceiptCount = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT Shipment_C__c, COUNT(Id) goodReceiptCount 
                                   FROM Good_Receipt__c 
                                   WHERE Shipment_C__c IN :shipmentId 
                                   GROUP BY Shipment_C__c]) {
            soToGoodReceiptCount.put((Id) ar.get('Shipment_C__c'), (Integer) ar.get('goodReceiptCount'));
        }
        
        // Loop through Shipment Orders and create Good Receipts if none exist
        for(Self_Shipment__c so : shipmentRecord) {
            Integer goodReceiptnumber = soToGoodReceiptCount.get(so.Id);
            if (goodReceiptnumber == null) {
                goodReceipts.add(new Good_Receipt__c(
                   Dealer_Account__c = so.Dealer_Account__c,
                   Purchase_Order__c = so.Purchase_Order__c,
                   Shipment_C__c = so.Id,
                   Suplier_Account__c =so.Suplier_Account__c,
                   Status__c = 'Draft'
                ));
            }
        }
        
        System.debug('goodReceipts--->' + goodReceipts);
        
        if(!goodReceipts.isEmpty()) {
            try {
                insert goodReceipts;
            } catch (DmlException e) {
                System.debug('DML Exception: ' + e.getMessage());
                // Handle exceptions as needed
            }
        }
    }
}