/**
* @File Name : QuickAddItemPanelController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : August 18, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | August 18, 2024 |   | Initial Version
**/

public class QuickAddItemPanelController {

    @AuraEnabled(cacheable=true)
    public static List<Price_List__c> getPriceLists() {
        return [SELECT Id, Name FROM Price_List__c];
    }

    /*@AuraEnabled(cacheable=true)
    public static List<Tax_Group__c> getTaxGroups() {
        return [SELECT Id, Name FROM Tax_Group__c];
    }
*/
    @AuraEnabled(cacheable=true)
    public static List<Product2> getItems(Id priceListId) {
        return [SELECT Id, Name FROM Product2 WHERE Price_List__c = :priceListId];
    }
@AuraEnabled(cacheable=true)
Public static List<Price_List_Rule__c> getPriceListRule(Id prodId)
  {
	return [Select Id,Name,Product__c,Price_List_Name__c,Unit_Price__c,Effective_from__c,Effective_Till__c from Price_List_Rule__c where Product__c =:prodId];
  }
  
  @AuraEnabled(cacheable=true)
public static List<Price_List_Rule__c> getPriceListRule2(Id productId, Id priceListId) {
    return [
        SELECT Product__c, Price_List_Name__c,product__r.Description, Unit_Price__c,Effective_from__c,Effective_Till__c
        FROM Price_List_Rule__c
        WHERE Product__c = :productId AND Price_List_Name__c = :priceListId
        LIMIT 1
    ];
}
@AuraEnabled(cacheable=true)
public static Purchase_Order__c getPoRecords(Id recordId )
  {
    Return [Select Id, Name	,Price_List__c,Purchase_Order_Amount__c,DealerAccounts__c from Purchase_Order__c where Id=:recordId limit 1];
   
  }

    @AuraEnabled
    public static void addItemToPurchaseOrder(Id purchaseOrderId, Id prodId, Id priceListId, Integer quantity, decimal unitCost) {
       
        Purchase_Order_Line__c newPOLineItem = new Purchase_Order_Line__c(
            Purchase_Order__c = purchaseOrderId,
            Product__c = prodId,
            Price_List__c = priceListId,
			Qunatity__c = quantity,
			Unit_Cost__c = unitCost

        );
        insert newPOLineItem;
      
    
        
    }
}