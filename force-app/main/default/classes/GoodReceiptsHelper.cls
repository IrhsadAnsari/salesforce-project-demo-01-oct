public class GoodReceiptsHelper {
    public static void goodReceiptLineCreation(Boolean isAfter, Boolean isInsert, List<Good_Receipt__c> goodReceipts)
    {
       Set<Id> shipmentId = new Set<Id>();
        for(Good_Receipt__c good : goodReceipts)
        {
            shipmentId.add(good.Shipment_C__c);
        }
        List<Shipment_Line_Item__c> shipmenLines = [Select Id,NAme,Purchase_Order_Line__c,Product__c,Quantity__c,Unit_Price__c,
                                                    Shipment__c	,Invoice_quantity__c ,Ordered_Quanity__c
                                                    from Shipment_Line_Item__c where Shipment__c In :shipmentId ];
        List<Good_Receipt_line__c> goodReceiptLines = new List<Good_Receipt_line__c>();
        for(Shipment_Line_Item__c shipmentline :shipmenLines)
        {
            Good_Receipt_line__c goodreceiptline = new Good_Receipt_line__c();
            for(Good_Receipt__c good : goodReceipts )
            {
                goodreceiptline.Good_Receipt__c =good.Id;
            }
            goodreceiptline.Product__c = shipmentline.Product__c ;
            goodreceiptline.Purchase_Order_Line__c = shipmentline.Purchase_Order_Line__c ;
            goodreceiptline .Shipment_Line_item__c = shipmentline.Id;
            goodreceiptline.Unit_Cost__c = shipmentline.Unit_Price__c;
            goodreceiptline.Ordered_Quanity__c = shipmentline.Ordered_Quanity__c;
            goodreceiptline.Invoiced_quantity__c = shipmentline.Invoice_quantity__c;
            goodReceiptLines.add(goodreceiptline); 
        }
        if(!goodReceiptLines.isEmpty())
        {
            try{
                insert goodReceiptLines;
            }
            catch(Exception e)
            {
                System.debug('There is exception occured during insertion' +e.getMessage());
            }
        }
        
    }

}