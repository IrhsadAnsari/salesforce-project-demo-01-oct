public class OpportunityHelper {
    public static void opportunityAmountValidate(Map<Id, Opportunity> oldOpportunities, Map<Id, Opportunity> newOpportunities) {
        for (Id oppId : newOpportunities.keySet()) {
            Opportunity newOpp = newOpportunities.get(oppId);
            Opportunity oldOpp = oldOpportunities.get(oppId);
            
            if (oldOpp != null && newOpp.Amount != oldOpp.Amount) {
                newOpp.Amount.addError('Amount cannot be changed!');
            }
        }
    }
    
   //When ever Opportunity "Stage" is modified to "Closed Won" then set "Close Date" as "Today Date" and "Type" as "New Customer".
   public static void opportunityClosedDateToday(Map<Id, Opportunity> oldOpportunity, Map<Id, Opportunity> newOpportunity)
   {
      // Set<Id> keys = oldOpportunty.keySet();
       for(Id rid: oldOpportunity.keySet())
       {
           Opportunity oldOpp = oldOpportunity.get(rid);
           Opportunity newOpp = newOpportunity.get(rid);
           if(oldOpp.StageName !='Closed Won' && newOpp.StageName == 'Closed Won')
           {
               newOpp.CloseDate = System.Today();
               newOpp.Type ='New Customer';
               System.debug('New oppp type--'+newOpp.Type);
           }  
       }
   }
    
    //Stock Deduction on the Clicking of Update Opportunity button on deatil page of Opportunity
    // based on the product added in the Opportunity line 
  public static void inventoryDeduction(Boolean isUpdate, List<Opportunity> oldOpp)
  {
      Set<Id> oppId =new Set<Id>();
      Set<Id> accountId =new Set<Id>();
      Set<Id> prodId = new Set<Id>();
      Integer qty=0;
      if(isUpdate)
      {
        System.debug('Opportunity---'+oldOpp);
      List<OpportunityLineItem> lineitem = new List<OpportunityLineItem>();
      for(Opportunity o:oldOpp)
      {
          oppId.add(o.Id);
          accountId.add(o.AccountId);
      } /*
      For(Opportunity o:oldOpp)
      {
               For(Opportunity n:newOpp)
               {
                   if(o.DeductInventory__c==false && o.StageName!='Closed Won')
                   {
                        oppId.add(o.Id);
                        accountId.add(o.AccountId);
                   }
                   else{
                       System.debug('Stock has  already dedutcted. ');
                   }
               }
 
      }
*/      
      lineitem = [Select Id,Product2Id,Quantity, OpportunityId from OpportunityLineItem where OpportunityId IN:oppId];
      
      System.debug('OpportunityLineItem---'+lineitem);
      for(OpportunityLineItem line:lineitem)
      {
          prodId.add(line.Product2Id);
          qty=(Integer)line.Quantity;
      }
      //if()
      List<Stock__c> exstingstockList =[Select Id,Dealer_Account__c,Product__c,Inhand_Quantity__c,Onhand_Quantity__c from Stock__c where Product__c In:prodId and Dealer_Account__c =:accountId ];
      System.debug('exstingstockList---'+exstingstockList);
      List<Stock__c>newStockList = New List<Stock__c>();
    For(Stock__c stock : exstingstockList)
      {
          stock.Inhand_Quantity__c =stock.Inhand_Quantity__c - qty;
          stock.Onhand_Quantity__c =stock.Onhand_Quantity__c - qty;
          newStockList.add(stock);

      }
      System.debug('newStockList---'+newStockList);
      if(newStockList.size()>0)
      {
          update newStockList;
      }
      }
       
  }
@AuraEnabled
public static List<Contact> searchProducts(String searchKey) {
   String searchTerm = '%' + searchKey + '%';
     return [SELECT Id, FirstName, LastName  FROM Contact WHERE LastName LIKE : searchTerm ];
}

    @AuraEnabled
    public static void updateContactOnOppty(List<Opportunity> optylist) {
           try {
         update optylist;
         } catch (Exception e) {
         throw new AuraHandledException('Error updating Opportunities: ' + e.getMessage());
             }

        }

}