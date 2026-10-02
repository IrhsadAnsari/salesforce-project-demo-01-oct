public with sharing class CommonHelper {
    public CommonHelper() {

    }
    //Write a method for trigger to retrun number of opportunity on account Record 
    // whenever Opportunity ie updated deleted and created--RollUp summary on Lookup relationship
    Public static void rollUpOpportunity(Boolean isInsert, Boolean isUpdate, Boolean isDelete,
     List<Opportunity> newEntries, List<Opportunity> oldEntries)
     {
         try{
        Map<Id, Opportunity> accToOppMap = new Map<Id, Opportunity>();
        List<Opportunity> Opplist = (newEntries != null && newEntries.size() > 0)? newEntries :oldEntries;
        if(isInsert || isDelete)
        {
            for(Opportunity opp : Opplist)
            {
                accToOppMap.put(opp.AccountId, Opp);
            }
        }
        List<Account> accList = [Select id,Name,NumberOFOpportunity__c from Account where Id In : accToOppMap.keySet()];
        Map<Id, Decimal> accountToOpptyCount = new Map<Id, Decimal>();
        List<AggregateResult> AR = [Select AccountId, Count(Id) OptyCount from Opportunity where AccountId In :  AccToOppMap.keySet() Group By AccountId];
        List<Account> accountToBeUpdated = new List<Account>();
        for(AggregateResult a : AR)
        {
            accountToOpptyCount.put((ID)a.get('AccountId'), (Decimal)a.get('OptyCount'));
        }
        if(accList.size() > 0)
        {
            for(Account acc : accList)
            {
                if(accountToOpptyCount.get(acc.Id) > 0)
                {
                    acc.NumberOFOpportunity__c = accountToOpptyCount.get(acc.Id);
                    accountToBeUpdated.add(acc); 
                }
            }  
        }
        if(accountToBeUpdated.size() > 0)
        update accountToBeUpdated;
         }
         catch(Exception e){
             //logExceptionHelper.logError(e);//Direct Error log creation
             logExceptionHelper.logExceptionError(e);//by Platform event
             throw e;
         }
         finally{
            //logExceptionHelper.logError(e);//Direct Error log creation// here e is not Exist hence Exception can not be captured in the Finally
         }
     }
     //Write a trigger to count Number of Opportunity line Related with that account whenever an
     //Opportunity line item inserted,Deleted,Upadted 
     public static void rollUpOpportunityLineItem(Boolean isInsert,Boolean isUpdate, Boolean isDelete,
     List<OpportunityLineItem> newEntries, List<OpportunityLineItem> oldEntries)
     {
        Map<Id,OpportunityLineItem> AccToOppOLi= new Map<Id, OpportunityLineItem>();
        List<OpportunityLineItem> oliItem = (newEntries != null && newEntries.size() > 0) ? newEntries :oldEntries;
        if(isInsert || isDelete)
        {
            if(oliItem.size() > 0)
            {
            for(OpportunityLineItem oli : oliItem)
               { 
                 AccToOppOLi.put(oli.Opportunity.AccountId, oli);
               }
           }
        }
        Map<Id, Decimal> AccToOliCount = new Map<Id, Decimal>();
        List<Account> accList = [Select Id, No_Of_Oli__c from Account where Id IN :AccToOppOLi.keySet()];
        List<AggregateResult> results = [Select Opportunity.AccountId, Count(id) OliCount from OpportunityLineItem where Opportunity.AccountId In : AccToOppOLi.keySet() Group by Opportunity.AccountId];
        for(AggregateResult AR : results)
        {
            AccToOliCount.put((ID)AR.get('Opportunity.AccountId'),(Decimal)AR.get('OliCount'));
        }
        List<Account> accountToBeUpdated =new List<Account>();
        if(accList.size() > 0)
        {
           for(Account acc : accList)
           {
            if(AccToOliCount.get(acc.id) > 0)
            {
                acc.No_Of_Oli__c = AccToOliCount.get(Acc.Id);
                accountToBeUpdated.add(acc);
            }
           }
        }
        if(accountToBeUpdated.size() > 0)
        {
            update accountToBeUpdated;
        }
     }
}