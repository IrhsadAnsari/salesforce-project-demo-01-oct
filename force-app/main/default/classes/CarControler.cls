public with sharing class CarControler {
    @auraEnabled(cacheable=true)
    public static List<Car__c> getCars(){
        return [Select Id, Name, Picture_URL__c,Category__c,Make__c,MSRP__c,Number_of_Seats__c,
        Control__c,Fuel_Type__c,Description__c from Car__c];
    }
}