public with sharing class AccountController {
    
@AuraEnabled(cacheable=true)
 public static List<Account> getAccountList()
 {
    return [Select Id,Name,Type,Industry from Account limit 5];
 } 
 @AuraEnabled(cacheable=true)  
 public static List<Account> filterAccountTypeType(String type)
 {
    return [SELECT Id, Name, Type, Industry from Account where Type=:type limit 5];
 } 
 @AuraEnabled(cacheable=true)
 public static List<Account> getAccountDetails(String accName) {
   String accountName='%'+accName+'%';
   return [Select Id,Name,Type,Industry from Account where Name like :accountName];
}
@AuraEnabled(cacheable=true)
public static List<Account> getAccountList2()
 {
     List<Account> accList =  [Select Id,Name,Industry,Phone from Account where Name like '%S%'];
    return accList;
 } 

@AuraEnabled
 public static List<Account> getAccount(Integer offsetValue)
 {
   return [Select Id,Name,Industry,Phone from Account limit 10 OFFSET :offsetValue];
 }
 
 @AuraEnabled(cacheable=true)
 Public static List<Account> getAccountLookUp(String searchKey)
 {
   try{
      String searchTerm = '\'%'+searchKey+'%\'';
      //return [Select Id,Name from Account where Name like '%searchKey%' ];
     // query = 'SELECT Id, ' + fieldName + ' FROM Account WHERE ' + fieldName +' LIKE ' + searchTerm +' LIMIT 10';
     String query ='Select Id, Name,Phone,Rating,Industry From Account Where Name Like '+searchTerm + ' LIMIT 10';
     return Database.query(query);
   }
   catch(Exception e)
    {
      throw new AuraHandledException('Record Not found'+ e.getMessage());
    }

  }

  @AuraEnabled
  public static void saveContact(Contact contactToInsert)
  {
   try{
      if(contactToInsert != null)
      insert contactToInsert;
   }
   catch(Exception e){
      throw new AuraHandledException('No Record found for insertion :'+e.getMessage());
   }
  }

@AuraEnabled(cacheable=true)
 public static List<Account> getAccountRecord(String searchKey)
 {
   try{
      String searchTerm = '\'%'+searchKey+'%\'';
      //return [Select Id,Name from Account where Name like '%searchKey%' ];
     // query = 'SELECT Id, ' + fieldName + ' FROM Account WHERE ' + fieldName +' LIKE ' + searchTerm +' LIMIT 10';
     String query ='Select Id, Name,Phone,Rating,Industry From Account Where Name Like '+searchTerm + ' LIMIT 10';
     return Database.query(query);
   }
   catch(Exception e)
    {
      throw new AuraHandledException('Record Not found'+ e.getMessage());
    }

  }
  @AuraEnabled(cacheable=true)
 public static List<Account> getAccountRecords(String searchKey)
 {
   try{
      String searchTerm = '\'%'+searchKey+'%\'';
      //return [Select Id,Name from Account where Name like '%searchKey%' ];
     // query = 'SELECT Id, ' + fieldName + ' FROM Account WHERE ' + fieldName +' LIKE ' + searchTerm +' LIMIT 10';
     String query ='Select Id, Name,Phone,Rating,Industry From Account Where Name Like '+searchTerm + ' LIMIT 10';
     return Database.query(query);
   }
   catch(Exception e)
    {
      throw new AuraHandledException('Record Not found'+ e.getMessage());
    }

  }
@AuraEnabled
public static void updateAccounts(
    String accountsJson
){

    List<Account> accounts =
        (List<Account>)
        JSON.deserialize(
            accountsJson,
            List<Account>.class
        );

    update accounts;
}

@AuraEnabled(cacheable=true)
    public static List<Account> getAccountsInfinite(String searchTerm, Integer limitSize, Integer offset) {
        String key = '%' + String.escapeSingleQuotes(searchTerm) + '%';
        
        if (String.isBlank(searchTerm)) {
            return [SELECT Id, Name, Industry, Phone FROM Account ORDER BY Name LIMIT :limitSize OFFSET :offset];
        } else {
            return [SELECT Id, Name, Industry, Phone FROM Account WHERE Name LIKE :key ORDER BY Name LIMIT :limitSize OFFSET :offset];
        }
    }
}