public class CreateAccountRecordCTRL {
     @AuraEnabled
    public static String createAccountRecs( String accountName, String accountPhone, String accountRating, date accountCreationDate)
    {
        Account acc= new Account();
        acc.Name=accountName;
        acc.Phone=accountPhone;
        acc.Rating=accountRating;
        acc.Account_Creation_date__c=accountCreationDate;
       insert acc;
       return acc.id;
    }
}