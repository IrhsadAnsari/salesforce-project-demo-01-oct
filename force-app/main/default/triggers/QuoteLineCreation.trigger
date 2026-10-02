trigger QuoteLineCreation on Quote__c (after insert) {
    Quote__c Q=trigger.new[0];
Opportunity OptyId=[select id from Opportunity where id=:Q.Opportunity_Name__c];  //Fetching Opty Id

List<OpportunityLineItem> OppLine=[select id, Quantity,TotalPrice,Product2Id, PriceBookEntry.Product2Id,UnitPrice,PriceBookEntryId
from OpportunityLineItem where OpportunityId=:OptyId.id];

 for(OpportunityLineItem QuoteLine:OppLine){
      Quote_Line_Item__c qli = new Quote_Line_Item__c();//creating a sobject for Quote_Line_Item__c
     
     /* Assigning OpportunityLineItem field into Quote_Line_Item__c*/
      qli.Quote_Id__c	 = Q.id;
      //qli.PricebookEntryId = QuoteLine.PriceBookEntryId;
     qli.Product_Id__c = QuoteLine.Product2Id	;
      qli.Qunatity__c = QuoteLine.Quantity;
      qli.Unit_Price__c = QuoteLine.UnitPrice;
     qli.Total_Price__c=QuoteLine.TotalPrice;
      //qli.Product2Id = QuoteLine.PriceBookEntry.Product2Id;
      //qli.Description = QuoteLine.Description;
      insert qli;
    }    

}