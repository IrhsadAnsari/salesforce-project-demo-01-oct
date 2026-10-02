public class InventoryLedgerHelper {
public static void stockPosting(Boolean isAfter, Boolean isUpdate, Boolean isInsert, List<Inventory_Ledger__c> inventoryledgers) {
    if (isAfter) {
        if (isInsert || isUpdate) {
            Set<Id> accountId = new Set<Id>();
            Set<Id> locationId = new Set<Id>();
            Set<Id> productId = new Set<Id>();

            // Step 1: Collect necessary IDs
            for (Inventory_Ledger__c ledger : inventoryledgers) {
                if (ledger.Dealer_Account__c != null && ledger.Storage_Location__c != null && ledger.Product__c != null) {
                    accountId.add(ledger.Dealer_Account__c);
                    locationId.add(ledger.Storage_Location__c);
                    productId.add(ledger.Product__c);
                }
            }

            // Step 2: Query existing Stock__c records based on those IDs
            List<Stock__c> existingStockList = [
                SELECT Id, Dealer_Account__c, Inhand_Quantity__c, Onhand_Quantity__c, Product__c, Storage_Location__c
                FROM Stock__c
                WHERE Dealer_Account__c IN :accountId
                  AND Product__c IN :productId
                  AND Storage_Location__c IN :locationId
            ];

            List<Stock__c> stocksToUpdate = new List<Stock__c>();
            List<Stock__c> stocksToInsert = new List<Stock__c>();

            // Step 3: Process each Inventory_Ledger__c and update or create Stock__c records
            for (Inventory_Ledger__c ledger : inventoryledgers) {
                Boolean stockFound = false;

                // Compare each Stock__c record with the current Inventory_Ledger__c fields
                for (Stock__c stock : existingStockList) {
                    if (stock.Dealer_Account__c == ledger.Dealer_Account__c &&
                        stock.Product__c == ledger.Product__c &&
                        stock.Storage_Location__c == ledger.Storage_Location__c) {
                        // Update existing stock quantities
                        stock.Inhand_Quantity__c += ledger.Quantity__c;
                        stock.Onhand_Quantity__c += ledger.Quantity__c;
                        stocksToUpdate.add(stock);
                        stockFound = true;
                        break; // Move to the next ledger since we found a match
                    }
                }

                // If no matching stock was found, create a new Stock__c record
                if (!stockFound) {
                    Stock__c newStock = new Stock__c();
                    newStock.Dealer_Account__c = ledger.Dealer_Account__c;
                    newStock.Product__c = ledger.Product__c;
                    newStock.Storage_Location__c = ledger.Storage_Location__c;
                    newStock.Inhand_Quantity__c = ledger.Quantity__c;
                    newStock.Onhand_Quantity__c = ledger.Quantity__c;
                    stocksToInsert.add(newStock);
                }
            }

            // Step 4: Perform bulk DML operations
            if (!stocksToUpdate.isEmpty()) {
                update stocksToUpdate;
            }

            if (!stocksToInsert.isEmpty()) {
                insert stocksToInsert;
            }
        }
    }
  }
}