public class AdjustmentHelper {
/*public static void inventoryPsoting(Boolean isUpdate, List<Adjustment__c> newEntries, List<Adjustment__c> oldEntries)
   {
       Set<Id> adjustmentId = new Set<Id>();
       Set<Id> accountId = new Set<Id>();
       
    If(isUpdate)
    {
        for(Adjustment__c entry :newEntries)
        {
            adjustmentId.add(entry.Id);
            accountId.add(entry.Dealer_Account__c);
        }
        List<Adjustment_Line__c> adjustmentLines = [Select Id,Name,Excess_quantity__c,Shortage_Quantity__c,Quantity__c,Inventory_Ledger__c,
                                                    Product__c,Storage_Location__c,Unit_Cost__c from Adjustment_Line__c where Adjustment__c In:adjustmentId ];
        List<Inventory_Ledger__c> inventoryLedgers =new List<Inventory_Ledger__c>();
        for(Adjustment__c newentry : newEntries)
        {
            for(Adjustment__c oldentry : oldEntries)
            {
                if(newentry.Status__c =='Adjusted' and oldentry.Status__c =='Draft'and newentry.Perform_Inventory_Posting__c == true and inventoryLedgers.size()>0 )
                {
                    insert inventoryLedgers;
                }
            }
        }
    }
   }*/
    //****************************-------------------------------*****************************
  public static void inventoryPosting(List<Adjustment__c> newEntries, Map<Id, Adjustment__c> oldEntryMap) {
    List<Inventory_Ledger__c> inventoryLedgersToInsert = new List<Inventory_Ledger__c>();
    Set<Id> adjustmentId = new Set<Id>();
    Id accountId;

    // Step 1: Gather all the records that meet the conditions
    for (Adjustment__c newEntry : newEntries) {
        Adjustment__c oldEntry = oldEntryMap.get(newEntry.Id);

        if (newEntry.Status__c == 'Adjusted'
            && oldEntry != null
            && oldEntry.Status__c == 'Draft'
            && newEntry.Perform_Inventory_Posting__c == true) {

            // Add to the set of adjustment Ids to query related lines
            adjustmentId.add(newEntry.Id);
            accountId = newEntry.Dealer_Account__c;
        }
    }
    System.debug('accountId--->' + accountId);
    System.debug('adjustmentId--->' + adjustmentId);

    // Step 2: Query related AdjustmentLine__c records in bulk
    if (!adjustmentId.isEmpty()) {
        List<Adjustment_Line__c> adjustmentLines = [
            Select Id, Name, Excess_quantity__c, Shortage_Quantity__c, Quantity__c, Inventory_Ledger__c,
                   Product__c, Storage_Location__c, Unit_Cost__c 
            from Adjustment_Line__c 
            where Adjustment__c IN :adjustmentId
        ];

        // Step 3: Create InventoryLedger__c records from adjustment lines
        Map<Id, Inventory_Ledger__c> ledgerMap = new Map<Id, Inventory_Ledger__c>();
        for (Adjustment_Line__c line : adjustmentLines) {
            // Check if Inventory Ledger is already set for this line
            if (line.Inventory_Ledger__c == null) {
                Inventory_Ledger__c inventoryLedger = new Inventory_Ledger__c();

                if (line.Excess_quantity__c != null && line.Excess_quantity__c > 0) {
                    inventoryLedger.Quantity__c = line.Excess_quantity__c;
                } else if (line.Shortage_Quantity__c != null && line.Shortage_Quantity__c > 0) {
                    inventoryLedger.Quantity__c = line.Shortage_Quantity__c;
                }
                inventoryLedger.Product__c = line.Product__c;
                inventoryLedger.Storage_Location__c = line.Storage_Location__c;
                inventoryLedger.Dealer_Account__c = accountId;
                inventoryLedger.Ledger_Type__c = 'Adjustment';
                inventoryLedger.Is_Stock_Posted__c = true;

                inventoryLedgersToInsert.add(inventoryLedger);
                ledgerMap.put(line.Id, inventoryLedger); // Store the ledger to map it back to the line
            }
        }

        // Step 4: Bulk insert the Inventory Ledger records
        if (!inventoryLedgersToInsert.isEmpty()) {
            insert inventoryLedgersToInsert;
            
            // Step 5: Update Adjustment Line records with the newly created Inventory Ledger Ids
            List<Adjustment_Line__c> adjustmentLinesToUpdate = new List<Adjustment_Line__c>();
            for (Adjustment_Line__c line : adjustmentLines) {
                if (ledgerMap.containsKey(line.Id)) {
                    line.Inventory_Ledger__c = ledgerMap.get(line.Id).Id; // Set the Inventory Ledger ID on the line
                    adjustmentLinesToUpdate.add(line);
                }
            }
            if (!adjustmentLinesToUpdate.isEmpty()) {
                update adjustmentLinesToUpdate; // Update the adjustment lines with Inventory Ledger Ids
            }
        }
    }
}

}