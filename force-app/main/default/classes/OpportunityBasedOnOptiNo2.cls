public with sharing class OpportunityBasedOnOptiNo2 {
   
    @AuraEnabled(cacheable=true)
    public static Opportunity opportunityNo(String opptyNo) {
          String opptyReference='%'+opptyNo+'%';
          Opportunity opp=[Select Id,Name,OwnerId,Opportuniyt_No__c from Opportunity where Opportuniyt_No__c like :opptyReference limit 1];
          return opp;
    }
}